import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty, MinLength } from 'class-validator';

export class DisableMfaDto {
  @ApiProperty({
    description: 'Current password for verification',
    example: 'MySecurePassword123!',
  })
  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  password: string;
}

