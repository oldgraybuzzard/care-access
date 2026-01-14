import { IsString, IsOptional, IsEnum, IsArray, IsUUID } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum DocumentCategory {
  PHOTO = 'photo',
  MEDICAL = 'medical',
  LEGAL = 'legal',
  EDUCATION = 'education',
  CASE_NOTE = 'case_note',
  REPORT = 'report',
  IMPORT = 'import',
  OTHER = 'other',
}

export class UploadDocumentDto {
  @ApiProperty({ enum: DocumentCategory, description: 'Document category' })
  @IsEnum(DocumentCategory)
  category: DocumentCategory;

  @ApiPropertyOptional({ description: 'Optional description of the document' })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional({ description: 'Searchable tags', type: [String] })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  tags?: string[];

  @ApiPropertyOptional({ description: 'Child ID to attach document to' })
  @IsOptional()
  @IsUUID()
  childId?: string;

  @ApiPropertyOptional({ description: 'Case ID to attach document to' })
  @IsOptional()
  @IsUUID()
  caseId?: string;

  @ApiPropertyOptional({ description: 'Client ID to attach document to' })
  @IsOptional()
  @IsUUID()
  clientId?: string;

  @ApiPropertyOptional({ description: 'Assessment ID to attach document to' })
  @IsOptional()
  @IsUUID()
  assessmentId?: string;
}

