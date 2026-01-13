import { Injectable } from '@nestjs/common';
import * as speakeasy from 'speakeasy';
import * as QRCode from 'qrcode';
import { randomBytes } from 'crypto';

@Injectable()
export class MfaService {
  /**
   * Generate MFA secret and QR code for user
   */
  async generateMfaSecret(email: string): Promise<{
    secret: string;
    qrCode: string;
    backupCodes: string[];
  }> {
    // Generate secret
    const secret = speakeasy.generateSecret({
      name: `FCF Platform (${email})`,
      issuer: 'FCF Platform',
    });

    // Generate QR code
    const qrCode = await QRCode.toDataURL(secret.otpauth_url);

    // Generate backup codes
    const backupCodes = this.generateBackupCodes(10);

    return {
      secret: secret.base32,
      qrCode,
      backupCodes,
    };
  }

  /**
   * Verify TOTP token
   */
  verifyToken(secret: string, token: string): boolean {
    return speakeasy.totp.verify({
      secret,
      encoding: 'base32',
      token,
      window: 2, // Allow 2 time steps before/after (60 seconds tolerance)
    });
  }

  /**
   * Generate backup codes
   */
  private generateBackupCodes(count: number): string[] {
    const codes: string[] = [];
    for (let i = 0; i < count; i++) {
      // Generate 8-character hex code
      const code = randomBytes(4).toString('hex').toUpperCase();
      codes.push(code);
    }
    return codes;
  }

  /**
   * Verify backup code and remove it from the list
   */
  verifyBackupCode(
    backupCodes: string[],
    code: string,
  ): {
    valid: boolean;
    remainingCodes: string[];
  } {
    const normalizedCode = code.toUpperCase().replace(/\s/g, '');
    const index = backupCodes.indexOf(normalizedCode);

    if (index === -1) {
      return { valid: false, remainingCodes: backupCodes };
    }

    // Remove used backup code
    const remainingCodes = backupCodes.filter((_, i) => i !== index);

    return { valid: true, remainingCodes };
  }
}

