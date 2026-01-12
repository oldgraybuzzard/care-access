import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty, IsOptional, IsEnum, IsObject } from 'class-validator';

export class CreateOrganizationDto {
  @ApiProperty({ example: 'Foster Care Foundation' })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiProperty({ example: 'fcf' })
  @IsString()
  @IsNotEmpty()
  slug: string;

  @ApiProperty({ example: 'enterprise', enum: ['free', 'basic', 'professional', 'enterprise'] })
  @IsEnum(['free', 'basic', 'professional', 'enterprise'])
  @IsOptional()
  plan?: string;

  @ApiProperty({ example: 'active', enum: ['active', 'suspended', 'cancelled'] })
  @IsEnum(['active', 'suspended', 'cancelled'])
  @IsOptional()
  status?: string;

  @ApiProperty({ example: { primaryColor: '#1976d2', logo: 'https://...' }, required: false })
  @IsObject()
  @IsOptional()
  branding?: any;

  @ApiProperty({ example: { maxUsers: 100, maxStorage: 1000 }, required: false })
  @IsObject()
  @IsOptional()
  settings?: any;
}

