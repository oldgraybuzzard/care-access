import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsNotEmpty, IsOptional, IsDateString, IsArray, IsObject } from 'class-validator';

export class CreateChildDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  clientId?: string;

  @ApiProperty()
  @IsNotEmpty()
  @IsString()
  firstName: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  middleName?: string;

  @ApiProperty()
  @IsNotEmpty()
  @IsString()
  lastName: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  nickname?: string;

  @ApiProperty()
  @IsNotEmpty()
  @IsDateString()
  dateOfBirth: string;

  @ApiProperty()
  @IsNotEmpty()
  @IsString()
  gender: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  raceEthnicity?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  preferredLanguage?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  photoUrl?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  ssn?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  medicaidId?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  schoolId?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  status?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  custodyStatus?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  legalStatus?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  referralSource?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  referralReason?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  presentingIssues?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsArray()
  medications?: any[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsArray()
  allergies?: any[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsArray()
  medicalConditions?: any[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsArray()
  mentalHealthDx?: any[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsArray()
  triggers?: any[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsArray()
  copingMechanisms?: any[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  traumaHistory?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  attachmentStyle?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsArray()
  interests?: any[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsArray()
  strengths?: any[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsArray()
  likes?: any[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsArray()
  dislikes?: any[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsArray()
  fears?: any[];
}

