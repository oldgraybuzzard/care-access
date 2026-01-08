import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { ExtendedReachService } from './extendedreach.service';
import { ZohoService } from './zoho.service';

@Module({
  imports: [HttpModule],
  providers: [ExtendedReachService, ZohoService],
  exports: [ExtendedReachService, ZohoService],
})
export class IntegrationsModule {}

