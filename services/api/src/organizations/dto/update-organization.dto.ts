import {
  IsString,
  IsOptional,
  IsEmail,
  IsUrl,
  MaxLength,
  IsHexColor,
} from 'class-validator';

export class UpdateOrganizationDto {
  @IsOptional()
  @IsString()
  @MaxLength(100)
  name?: string;

  @IsOptional()
  @IsString()
  @MaxLength(20)
  phone?: string;

  @IsOptional()
  @IsEmail()
  email?: string;

  @IsOptional()
  @IsUrl()
  website?: string;

  @IsOptional()
  @IsString()
  @MaxLength(200)
  address?: string;

  @IsOptional()
  @IsString()
  @MaxLength(100)
  city?: string;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  state?: string;

  @IsOptional()
  @IsString()
  @MaxLength(20)
  zipCode?: string;

  @IsOptional()
  @IsString()
  @MaxLength(100)
  country?: string;

  @IsOptional()
  @IsString()
  @MaxLength(1000)
  description?: string;

  @IsOptional()
  @IsHexColor()
  primaryColor?: string;
}

