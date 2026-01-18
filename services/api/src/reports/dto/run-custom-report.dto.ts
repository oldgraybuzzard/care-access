import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, IsOptional, IsObject, IsIn } from 'class-validator';

export class RunCustomReportDto {
  @ApiProperty({
    description: 'Dataset to query',
    enum: [
      'clients',
      'cases',
      'activities',
      'services',
      'children',
      'education',
      'behavioral_incidents',
      'goals',
      'assessments',
      'medical_records',
      'home_visits',
      'families'
    ]
  })
  @IsString()
  @IsNotEmpty()
  @IsIn([
    'clients',
    'cases',
    'activities',
    'services',
    'children',
    'education',
    'behavioral_incidents',
    'goals',
    'assessments',
    'medical_records',
    'home_visits',
    'families'
  ])
  dataset: string;

  @ApiProperty({ description: 'Report definition ID (if saving)', required: false })
  @IsString()
  @IsOptional()
  reportDefinitionId?: string;

  @ApiProperty({ description: 'Filters for the query', required: false })
  @IsObject()
  @IsOptional()
  filters?: {
    // Common filters
    programId?: string;
    workerId?: string;
    status?: string;
    startDate?: string;
    endDate?: string;

    // Case/Activity/Service filters
    activityType?: string;
    serviceType?: string;

    // Child filters
    childId?: string;
    ageMin?: number;
    ageMax?: number;
    gender?: string;
    gradeLevel?: string;
    schoolYear?: string;

    // Education filters
    hasIep?: boolean;
    has504Plan?: boolean;
    gpaMin?: number;
    gpaMax?: number;

    // Behavioral filters
    incidentType?: string;
    severityLevel?: string;

    // Goal filters
    goalCategory?: string;
    goalStatus?: string;

    // Family/Home Visit filters
    familyId?: string;

    [key: string]: any;
  };

  @ApiProperty({ description: 'Group by fields', required: false })
  @IsOptional()
  groupBy?: string[];
}

