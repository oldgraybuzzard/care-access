import { Module } from '@nestjs/common';
import { ChildrenService } from './children.service';
import { ChildrenController } from './children.controller';
import { EducationRecordsService } from './education-records.service';
import { EducationRecordsController } from './education-records.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { AuditModule } from '../audit/audit.module';

@Module({
  imports: [PrismaModule, AuditModule],
  controllers: [ChildrenController, EducationRecordsController],
  providers: [ChildrenService, EducationRecordsService],
  exports: [ChildrenService, EducationRecordsService],
})
export class ChildrenModule {}

