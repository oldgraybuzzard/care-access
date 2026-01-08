import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, IsOptional, IsObject, IsIn } from 'class-validator';

export class RunCustomReportDto {
  @ApiProperty({ description: 'Dataset to query', enum: ['clients', 'cases', 'activities', 'services'] })
  @IsString()
  @IsNotEmpty()
  @IsIn(['clients', 'cases', 'activities', 'services'])
  dataset: string;

  @ApiProperty({ description: 'Report definition ID (if saving)', required: false })
  @IsString()
  @IsOptional()
  reportDefinitionId?: string;

  @ApiProperty({ description: 'Filters for the query', required: false })
  @IsObject()
  @IsOptional()
  filters?: {
    programId?: string;
    workerId?: string;
    status?: string;
    activityType?: string;
    serviceType?: string;
    startDate?: string;
    endDate?: string;
    [key: string]: any;
  };

  @ApiProperty({ description: 'Group by fields', required: false })
  @IsOptional()
  groupBy?: string[];
}

