import { Module } from '@nestjs/common';
import { SyncJob } from './sync.job';
import { KpiRollupJob } from './kpi-rollup.job';
import { IntegrationsModule } from '../integrations/integrations.module';

@Module({
  imports: [IntegrationsModule],
  providers: [SyncJob, KpiRollupJob],
})
export class JobsModule {}

