# Adding Multi-Factor Authentication (MFA) to CareAccess

## Why MFA?

For nonprofits handling sensitive child/family data, MFA is:
- ✅ **Required** for SOC 2 / HIPAA compliance
- ✅ **Expected** by county/state partners
- ✅ **Critical** for preventing unauthorized access
- ✅ **Easy** to implement with TOTP (Google Authenticator, Authy)

---

## Implementation Plan (2-3 Days)

### Step 1: Add Database Fields

Create migration:

```bash
cd services/api
npx prisma migrate dev --name add_mfa_fields --create-only
```

Edit migration file:

```sql
-- Add MFA fields to User table
ALTER TABLE "User" ADD COLUMN "mfa_enabled" BOOLEAN DEFAULT FALSE;
ALTER TABLE "User" ADD COLUMN "mfa_secret" TEXT;
ALTER TABLE "User" ADD COLUMN "mfa_backup_codes" TEXT[];
```

Run migration:

```bash
npx prisma migrate dev
```

### Step 2: Update Prisma Schema

Edit `services/api/prisma/schema.prisma`:

```prisma
model User {
  id             String   @id @default(uuid())
  email          String   @unique
  name           String
  passwordHash   String   @map("password_hash")
  isActive       Boolean  @default(true) @map("is_active")
  organizationId String?  @map("organization_id")
  
  // MFA fields
  mfaEnabled     Boolean  @default(false) @map("mfa_enabled")
  mfaSecret      String?  @map("mfa_secret")
  mfaBackupCodes String[] @map("mfa_backup_codes")
  
  createdAt      DateTime @default(now()) @map("created_at")
  updatedAt      DateTime @updatedAt @map("updated_at")

  organization   Organization? @relation(fields: [organizationId], references: [id])
  roles          UserRole[]

  @@map("users")
}
```

### Step 3: Install Dependencies

```bash
cd services/api
npm install speakeasy qrcode
npm install --save-dev @types/speakeasy @types/qrcode
```

### Step 4: Create MFA Service

Create `services/api/src/auth/mfa.service.ts`:

```typescript
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
      name: `CareAccess (${email})`,
      issuer: 'CareAccess',
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
      window: 2, // Allow 2 time steps before/after
    });
  }

  /**
   * Generate backup codes
   */
  private generateBackupCodes(count: number): string[] {
    const codes: string[] = [];
    for (let i = 0; i < count; i++) {
      const code = randomBytes(4).toString('hex').toUpperCase();
      codes.push(code);
    }
    return codes;
  }

  /**
   * Verify backup code
   */
  verifyBackupCode(backupCodes: string[], code: string): {
    valid: boolean;
    remainingCodes: string[];
  } {
    const index = backupCodes.indexOf(code.toUpperCase());
    
    if (index === -1) {
      return { valid: false, remainingCodes: backupCodes };
    }

    // Remove used backup code
    const remainingCodes = backupCodes.filter((_, i) => i !== index);
    
    return { valid: true, remainingCodes };
  }
}
```

### Step 5: Add MFA Endpoints

Update `services/api/src/auth/auth.controller.ts`:

```typescript
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
    message: 'Scan QR code with authenticator app, then verify to enable MFA',
  };
}

@Post('mfa/verify')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
@ApiOperation({ summary: 'Verify and enable MFA' })
async verifyMfa(@Request() req, @Body() body: { token: string }) {
  const user = await this.usersService.findById(req.user.userId);

  if (!user.mfaSecret) {
    throw new BadRequestException('MFA setup not initiated');
  }

  const isValid = this.mfaService.verifyToken(user.mfaSecret, body.token);

  if (!isValid) {
    throw new UnauthorizedException('Invalid MFA token');
  }

  // Enable MFA
  await this.usersService.enableMfa(user.id);

  return { message: 'MFA enabled successfully' };
}

@Post('mfa/disable')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
@ApiOperation({ summary: 'Disable MFA' })
async disableMfa(@Request() req, @Body() body: { password: string }) {
  const user = await this.usersService.findById(req.user.userId);

  // Verify password before disabling MFA
  const isPasswordValid = await bcrypt.compare(body.password, user.passwordHash);
  
  if (!isPasswordValid) {
    throw new UnauthorizedException('Invalid password');
  }

  await this.usersService.disableMfa(user.id);

  return { message: 'MFA disabled successfully' };
}
```

### Step 6: Update Login Flow

Update `services/api/src/auth/auth.service.ts`:

```typescript
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
      expiresIn: '5m', // Short expiry
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

@Post('mfa/verify-login')
@ApiOperation({ summary: 'Verify MFA token during login' })
async verifyMfaLogin(@Body() body: { tempToken: string; token: string }) {
  const payload = this.jwtService.verify(body.tempToken);

  if (!payload.mfaRequired) {
    throw new UnauthorizedException('Invalid token');
  }

  const user = await this.usersService.findById(payload.sub);

  // Verify MFA token or backup code
  let isValid = this.mfaService.verifyToken(user.mfaSecret, body.token);

  if (!isValid) {
    // Try backup code
    const { valid, remainingCodes } = this.mfaService.verifyBackupCode(
      user.mfaBackupCodes,
      body.token,
    );

    if (valid) {
      // Update backup codes
      await this.usersService.updateBackupCodes(user.id, remainingCodes);
      isValid = true;
    }
  }

  if (!isValid) {
    throw new UnauthorizedException('Invalid MFA token');
  }

  // Generate full access tokens
  return this.generateTokens(user);
}
```

---

## Flutter App Changes

Update login flow to handle MFA:

```dart
// 1. Initial login
final response = await authApi.login(email, password);

if (response.mfaRequired) {
  // 2. Show MFA input screen
  final mfaToken = await showMfaDialog();
  
  // 3. Verify MFA
  final tokens = await authApi.verifyMfa(response.tempToken, mfaToken);
  
  // 4. Store tokens
  await secureStorage.write('accessToken', tokens.accessToken);
}
```

---

## Benefits

✅ **Security**: Prevents unauthorized access even if password is compromised  
✅ **Compliance**: Required for SOC 2 / HIPAA  
✅ **User-friendly**: Works with Google Authenticator, Authy, 1Password  
✅ **Backup codes**: Users can still login if they lose their device  

---

## Next Steps

1. Implement MFA backend (2 days)
2. Add MFA UI to Flutter app (1 day)
3. Test MFA flow (0.5 days)
4. Deploy to production

**Total**: 3-4 days to add enterprise-grade MFA

