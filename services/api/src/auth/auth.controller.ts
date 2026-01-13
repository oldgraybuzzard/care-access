import { Controller, Post, Body, UseGuards, Get, Request, Patch, BadRequestException, UnauthorizedException } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiBody } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
import { VerifyMfaDto } from './dto/verify-mfa.dto';
import { DisableMfaDto } from './dto/disable-mfa.dto';
import { VerifyMfaLoginDto } from './dto/verify-mfa-login.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { UsersService } from '../users/users.service';
import { MfaService } from './mfa.service';
import * as bcrypt from 'bcrypt';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(
    private authService: AuthService,
    private usersService: UsersService,
    private mfaService: MfaService,
  ) {}

  @Post('login')
  @ApiOperation({ summary: 'Login with email and password' })
  @ApiBody({ type: LoginDto })
  async login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  @Post('refresh')
  @ApiOperation({ summary: 'Refresh access token' })
  @ApiBody({ type: RefreshTokenDto })
  async refresh(@Body() refreshTokenDto: RefreshTokenDto) {
    return this.authService.refresh(refreshTokenDto.refreshToken);
  }

  @Post('logout')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Logout (client should discard tokens)' })
  async logout() {
    // In a stateless JWT setup, logout is handled client-side
    // For enhanced security, you could implement token blacklisting
    return { message: 'Logged out successfully' };
  }

  @Get('me')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get current user profile' })
  async getProfile(@Request() req) {
    const user = await this.usersService.findById(req.user.userId);
    const { passwordHash, ...result } = user;
    return result;
  }

  @Patch('change-password')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Change current user password' })
  @ApiBody({ type: ChangePasswordDto })
  async changePassword(@Request() req, @Body() changePasswordDto: ChangePasswordDto) {
    return this.authService.changePassword(
      req.user.userId,
      changePasswordDto.currentPassword,
      changePasswordDto.newPassword,
    );
  }

  // ============================================
  // MFA Endpoints
  // ============================================

  @Post('mfa/setup')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Setup MFA for current user' })
  async setupMfa(@Request() req) {
    const user = await this.usersService.findById(req.user.userId);

    if (user.mfaEnabled) {
      throw new BadRequestException('MFA is already enabled');
    }

    const { secret, qrCode, backupCodes } = await this.mfaService.generateMfaSecret(user.email);

    // Store secret temporarily (not enabled yet)
    await this.usersService.updateMfaSecret(user.id, secret, backupCodes);

    return {
      qrCode,
      backupCodes,
      message: 'Scan QR code with authenticator app (Google Authenticator, Authy, 1Password), then verify to enable MFA',
    };
  }

  @Post('mfa/verify')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Verify and enable MFA' })
  @ApiBody({ type: VerifyMfaDto })
  async verifyMfa(@Request() req, @Body() verifyMfaDto: VerifyMfaDto) {
    const user = await this.usersService.findById(req.user.userId);

    if (!user.mfaSecret) {
      throw new BadRequestException('MFA setup not initiated. Call /auth/mfa/setup first');
    }

    if (user.mfaEnabled) {
      throw new BadRequestException('MFA is already enabled');
    }

    const isValid = this.mfaService.verifyToken(user.mfaSecret, verifyMfaDto.token);

    if (!isValid) {
      throw new UnauthorizedException('Invalid MFA token');
    }

    // Enable MFA
    await this.usersService.enableMfa(user.id);

    return { message: 'MFA enabled successfully' };
  }

  @Post('mfa/verify-login')
  @ApiOperation({ summary: 'Verify MFA token during login' })
  @ApiBody({ type: VerifyMfaLoginDto })
  async verifyMfaLogin(@Body() verifyMfaLoginDto: VerifyMfaLoginDto) {
    return this.authService.verifyMfaLogin(
      verifyMfaLoginDto.tempToken,
      verifyMfaLoginDto.token,
    );
  }

  @Post('mfa/disable')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Disable MFA' })
  @ApiBody({ type: DisableMfaDto })
  async disableMfa(@Request() req, @Body() disableMfaDto: DisableMfaDto) {
    const user = await this.usersService.findById(req.user.userId);

    if (!user.mfaEnabled) {
      throw new BadRequestException('MFA is not enabled');
    }

    // Verify password before disabling MFA
    const isPasswordValid = await bcrypt.compare(disableMfaDto.password, user.passwordHash);

    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid password');
    }

    await this.usersService.disableMfa(user.id);

    return { message: 'MFA disabled successfully' };
  }
}

