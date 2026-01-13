import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsOptional, IsString, MinLength, IsBoolean } from 'class-validator';

export class UpdateSuperAdminDto {
  @ApiProperty({ example: 'admin@melkentechwork.com', required: false })
  @IsEmail()
  @IsOptional()
  email?: string;

  @ApiProperty({ example: 'Platform Administrator', required: false })
  @IsString()
  @IsOptional()
  name?: string;

  @ApiProperty({ example: 'NewSecurePassword123!', required: false })
  @IsString()
  @MinLength(8)
  @IsOptional()
  password?: string;

  @ApiProperty({ example: true, required: false })
  @IsBoolean()
  @IsOptional()
  isActive?: boolean;
}

