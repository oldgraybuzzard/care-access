import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, IsOptional, IsObject } from 'class-validator';

export class RunReportDto {
  @ApiProperty({ description: 'Report definition ID' })
  @IsString()
  @IsNotEmpty()
  reportDefinitionId: string;

  @ApiProperty({ description: 'Report filters', required: false })
  @IsObject()
  @IsOptional()
  filters?: {
    programId?: string;
    workerId?: string;
    status?: string;
    startDate?: string;
    endDate?: string;
    [key: string]: any;
  };
}

