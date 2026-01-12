import { IsString, IsOptional, IsNumber, IsBoolean, IsJSON, Min, Max } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateEducationRecordDto {
  @ApiProperty({ description: 'School year (e.g., 2023-2024)' })
  @IsString()
  schoolYear: string;

  @ApiProperty({ description: 'Name of the school' })
  @IsString()
  schoolName: string;

  @ApiProperty({ description: 'Grade level (e.g., 3rd, 4th, Kindergarten)' })
  @IsString()
  gradeLevel: string;

  // Academic Performance
  @ApiPropertyOptional({ description: 'Grade Point Average', minimum: 0, maximum: 4 })
  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(4)
  gpa?: number;

  @ApiPropertyOptional({ description: 'Reading level assessment' })
  @IsOptional()
  @IsString()
  readingLevel?: string;

  @ApiPropertyOptional({ description: 'Math level assessment' })
  @IsOptional()
  @IsString()
  mathLevel?: string;

  @ApiPropertyOptional({ description: 'Subjects the child is struggling with (JSON array)' })
  @IsOptional()
  strugglingSubjects?: any;

  // Attendance & Behavior
  @ApiPropertyOptional({ description: 'Number of days present' })
  @IsOptional()
  @IsNumber()
  @Min(0)
  daysPresent?: number;

  @ApiPropertyOptional({ description: 'Number of days absent' })
  @IsOptional()
  @IsNumber()
  @Min(0)
  daysAbsent?: number;

  @ApiPropertyOptional({ description: 'Number of tardies' })
  @IsOptional()
  @IsNumber()
  @Min(0)
  tardies?: number;

  @ApiPropertyOptional({ description: 'Number of suspensions' })
  @IsOptional()
  @IsNumber()
  @Min(0)
  suspensions?: number;

  @ApiPropertyOptional({ description: 'Number of detentions' })
  @IsOptional()
  @IsNumber()
  @Min(0)
  detentions?: number;

  // Special Education
  @ApiPropertyOptional({ description: 'Has an Individualized Education Program (IEP)' })
  @IsOptional()
  @IsBoolean()
  hasIep?: boolean;

  @ApiPropertyOptional({ description: 'Has a 504 Plan' })
  @IsOptional()
  @IsBoolean()
  has504Plan?: boolean;

  @ApiPropertyOptional({ description: 'Special education services (JSON array)' })
  @IsOptional()
  specialServices?: any;

  // Additional Info
  @ApiPropertyOptional({ description: 'Feedback from teachers' })
  @IsOptional()
  @IsString()
  teacherFeedback?: string;

  @ApiPropertyOptional({ description: 'Extracurricular activities (JSON array)' })
  @IsOptional()
  extracurricular?: any;
}

