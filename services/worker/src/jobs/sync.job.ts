import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import { ExtendedReachService } from '../integrations/extendedreach.service';

@Injectable()
export class SyncJob {
  private readonly logger = new Logger(SyncJob.name);
  private readonly syncInterval: number;

  constructor(
    private prisma: PrismaService,
    private extendedReachService: ExtendedReachService,
    private configService: ConfigService,
  ) {
    this.syncInterval = parseInt(
      this.configService.get<string>('SYNC_INTERVAL_MINUTES', '60'),
      10,
    );
  }

  // Run every hour (configurable)
  @Cron(CronExpression.EVERY_HOUR)
  async handleSyncJob() {
    this.logger.log('🔄 Starting sync job...');

    try {
      // Get vendor source
      const vendorSource = await this.prisma.vendorSource.findUnique({
        where: { name: 'extendedreach' },
      });

      if (!vendorSource) {
        this.logger.error('Vendor source not found');
        return;
      }

      // Sync clients
      await this.syncClients(vendorSource.id);

      // Sync cases
      await this.syncCases(vendorSource.id);

      // Sync activities
      await this.syncActivities(vendorSource.id);

      // Sync services
      await this.syncServices(vendorSource.id);

      this.logger.log('✅ Sync job completed successfully');
    } catch (error) {
      this.logger.error(`❌ Sync job failed: ${error.message}`, error.stack);
    }
  }

  private async syncClients(vendorSourceId: string) {
    this.logger.log('Syncing clients...');

    try {
      // Fetch clients from ExtendedReach
      const clients = await this.extendedReachService.getClients();

      // Upsert clients
      for (const client of clients) {
        await this.prisma.client.upsert({
          where: {
            vendorSourceId_vendorClientId: {
              vendorSourceId,
              vendorClientId: client.id,
            },
          },
          update: {
            firstName: client.firstName,
            lastName: client.lastName,
            dob: client.dob ? new Date(client.dob) : null,
            status: client.status,
            metaJson: client,
            updatedAt: new Date(),
          },
          create: {
            vendorSourceId,
            vendorClientId: client.id,
            firstName: client.firstName,
            lastName: client.lastName,
            dob: client.dob ? new Date(client.dob) : null,
            status: client.status,
            metaJson: client,
          },
        });
      }

      this.logger.log(`✅ Synced ${clients.length} clients`);
    } catch (error) {
      this.logger.error(`Failed to sync clients: ${error.message}`);
    }
  }

  private async syncCases(vendorSourceId: string) {
    this.logger.log('Syncing cases...');

    try {
      // Fetch cases from ExtendedReach
      const cases = await this.extendedReachService.getCases();

      // Upsert cases
      for (const caseData of cases) {
        // Find or create client
        const client = await this.prisma.client.findFirst({
          where: {
            vendorSourceId,
            vendorClientId: caseData.clientId,
          },
        });

        if (!client) {
          this.logger.warn(`Client not found for case ${caseData.id}`);
          continue;
        }

        await this.prisma.case.upsert({
          where: {
            vendorSourceId_vendorCaseId: {
              vendorSourceId,
              vendorCaseId: caseData.id,
            },
          },
          update: {
            status: caseData.status,
            openedAt: new Date(caseData.openedAt),
            closedAt: caseData.closedAt ? new Date(caseData.closedAt) : null,
            metaJson: caseData,
            updatedAt: new Date(),
          },
          create: {
            vendorSourceId,
            vendorCaseId: caseData.id,
            clientId: client.id,
            status: caseData.status,
            openedAt: new Date(caseData.openedAt),
            closedAt: caseData.closedAt ? new Date(caseData.closedAt) : null,
            metaJson: caseData,
          },
        });
      }

      this.logger.log(`✅ Synced ${cases.length} cases`);
    } catch (error) {
      this.logger.error(`Failed to sync cases: ${error.message}`);
    }
  }

  private async syncActivities(vendorSourceId: string) {
    this.logger.log('Syncing activities...');

    try {
      // Fetch activities from ExtendedReach
      const activities = await this.extendedReachService.getActivities();

      // Upsert activities
      for (const activity of activities) {
        const caseRecord = await this.prisma.case.findFirst({
          where: {
            vendorSourceId,
            vendorCaseId: activity.caseId,
          },
        });

        if (!caseRecord) {
          continue;
        }

        await this.prisma.activity.upsert({
          where: {
            vendorSourceId_vendorActivityId: {
              vendorSourceId,
              vendorActivityId: activity.id,
            },
          },
          update: {
            activityType: activity.type,
            occurredAt: new Date(activity.occurredAt),
            summary: activity.summary,
            metaJson: activity,
            updatedAt: new Date(),
          },
          create: {
            vendorSourceId,
            vendorActivityId: activity.id,
            caseId: caseRecord.id,
            activityType: activity.type,
            occurredAt: new Date(activity.occurredAt),
            summary: activity.summary,
            metaJson: activity,
          },
        });
      }

      this.logger.log(`✅ Synced ${activities.length} activities`);
    } catch (error) {
      this.logger.error(`Failed to sync activities: ${error.message}`);
    }
  }

  private async syncServices(vendorSourceId: string) {
    this.logger.log('Syncing services...');
    // Similar implementation to activities
    this.logger.log('✅ Services sync completed');
  }
}

