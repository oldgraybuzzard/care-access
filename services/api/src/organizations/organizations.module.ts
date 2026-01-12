import { Module } from '@nestjs/common';
import { OrganizationsService } from './organizations.service';
import { OrganizationsController, UserOrganizationsController } from './organizations.controller';

@Module({
  controllers: [OrganizationsController, UserOrganizationsController],
  providers: [OrganizationsService],
  exports: [OrganizationsService],
})
export class OrganizationsModule {}

