-- Add Multi-Factor Authentication (MFA) fields to User table
-- This enables TOTP-based 2FA for enhanced security

-- Add MFA enabled flag
ALTER TABLE "users" ADD COLUMN "mfa_enabled" BOOLEAN NOT NULL DEFAULT FALSE;

-- Add MFA secret (base32 encoded TOTP secret)
ALTER TABLE "users" ADD COLUMN "mfa_secret" TEXT;

-- Add MFA backup codes (array of one-time use codes)
ALTER TABLE "users" ADD COLUMN "mfa_backup_codes" TEXT[] NOT NULL DEFAULT '{}';

-- Add index for faster MFA lookups
CREATE INDEX "users_mfa_enabled_idx" ON "users"("mfa_enabled");

