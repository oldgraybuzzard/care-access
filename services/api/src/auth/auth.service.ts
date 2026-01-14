import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { UsersService } from '../users/users.service';
import { LoginDto } from './dto/login.dto';
import { MfaService } from './mfa.service';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
    private configService: ConfigService,
    private mfaService: MfaService,
  ) {}

  async validateUser(email: string, password: string): Promise<any> {
    const user = await this.usersService.findByEmail(email);

    if (!user) {
      return null;
    }

    const isPasswordValid = await bcrypt.compare(password, user.passwordHash);

    if (!isPasswordValid) {
      return null;
    }

    if (!user.isActive) {
      throw new UnauthorizedException('User account is inactive');
    }

    const { passwordHash, ...result } = user;
    return result;
  }

  async login(loginDto: LoginDto) {
    const user = await this.validateUser(loginDto.email, loginDto.password);

    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }

    // Check if MFA is enabled
    if (user.mfaEnabled) {
      // Return temporary token that requires MFA verification
      const tempPayload = {
        sub: user.id,
        email: user.email,
        mfaRequired: true,
      };

      const tempToken = this.jwtService.sign(tempPayload, {
        expiresIn: '5m', // Short expiry for temp token
      });

      return {
        mfaRequired: true,
        tempToken,
        message: 'MFA verification required',
      };
    }

    // Normal login flow (no MFA)
    return this.generateTokens(user);
  }

  /**
   * Generate access and refresh tokens for a user
   */
  private generateTokens(user: any) {
    const payload = {
      sub: user.id,
      email: user.email,
      roles: user.roles?.map(ur => ur.role.name) || [],
      organizationId: user.organizationId,
    };

    const accessToken = this.jwtService.sign(payload);
    const refreshToken = this.jwtService.sign(payload, {
      secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
      expiresIn: this.configService.get<string>('JWT_REFRESH_EXPIRATION', '7d'),
    });

    return {
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        roles: user.roles?.map(ur => ur.role.name) || [],
        organizationId: user.organizationId,
      },
    };
  }

  async refresh(refreshToken: string) {
    try {
      const payload = this.jwtService.verify(refreshToken, {
        secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
      });

      const user = await this.usersService.findById(payload.sub);
      
      if (!user || !user.isActive) {
        throw new UnauthorizedException('Invalid refresh token');
      }

      const newPayload = {
        sub: user.id,
        email: user.email,
        roles: user.roles?.map(ur => ur.role.name) || [],
        organizationId: user.organizationId,
      };

      const accessToken = this.jwtService.sign(newPayload);

      return {
        accessToken,
      };
    } catch (error) {
      throw new UnauthorizedException('Invalid refresh token');
    }
  }

  async validateToken(token: string) {
    try {
      const payload = this.jwtService.verify(token);
      return payload;
    } catch (error) {
      return null;
    }
  }

  async changePassword(userId: string, currentPassword: string, newPassword: string) {
    // Get user with password hash
    const user = await this.usersService.findById(userId);

    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    // Verify current password
    const isPasswordValid = await bcrypt.compare(currentPassword, user.passwordHash);

    if (!isPasswordValid) {
      throw new UnauthorizedException('Current password is incorrect');
    }

    // Hash new password
    const newPasswordHash = await bcrypt.hash(newPassword, 10);

    // Update password
    await this.usersService.updatePassword(userId, newPasswordHash);

    return { message: 'Password changed successfully' };
  }

  /**
   * Verify MFA token during login
   */
  async verifyMfaLogin(tempToken: string, token: string) {
    let payload: any;

    try {
      payload = this.jwtService.verify(tempToken);
    } catch (error) {
      throw new UnauthorizedException('Invalid or expired temporary token');
    }

    if (!payload.mfaRequired) {
      throw new UnauthorizedException('Invalid token');
    }

    const user = await this.usersService.findById(payload.sub);

    if (!user || !user.mfaEnabled) {
      throw new UnauthorizedException('Invalid MFA configuration');
    }

    // Verify MFA token or backup code
    let isValid = this.mfaService.verifyToken(user.mfaSecret, token);

    if (!isValid) {
      // Try backup code
      const { valid, remainingCodes } = this.mfaService.verifyBackupCode(
        user.mfaBackupCodes,
        token,
      );

      if (valid) {
        // Update backup codes (remove used code)
        await this.usersService.updateBackupCodes(user.id, remainingCodes);
        isValid = true;
      }
    }

    if (!isValid) {
      throw new UnauthorizedException('Invalid MFA token or backup code');
    }

    // Generate full access tokens
    return this.generateTokens(user);
  }
}

