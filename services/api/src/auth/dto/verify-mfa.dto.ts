import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty, Length } from 'class-validator';

export class VerifyMfaDto {
  @ApiProperty({
    description: 'TOTP token from authenticator app (6 digits)',
    example: '123456',
  })
  @IsString()
  @IsNotEmpty()
  @Length(6, 8)
  token: string;
}

