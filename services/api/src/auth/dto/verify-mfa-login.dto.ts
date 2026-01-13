import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty, Length } from 'class-validator';

export class VerifyMfaLoginDto {
  @ApiProperty({
    description: 'Temporary token from initial login',
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  })
  @IsString()
  @IsNotEmpty()
  tempToken: string;

  @ApiProperty({
    description: 'TOTP token from authenticator app or backup code',
    example: '123456',
  })
  @IsString()
  @IsNotEmpty()
  @Length(6, 8)
  token: string;
}

