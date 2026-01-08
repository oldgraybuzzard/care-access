import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';

@Injectable()
export class ExtendedReachService {
  private readonly logger = new Logger(ExtendedReachService.name);
  private readonly baseUrl: string;
  private readonly clientId: string;
  private readonly clientSecret: string;
  private accessToken: string | null = null;

  constructor(
    private configService: ConfigService,
    private httpService: HttpService,
  ) {
    this.baseUrl = this.configService.get<string>('EXTENDEDREACH_BASE_URL');
    this.clientId = this.configService.get<string>('EXTENDEDREACH_CLIENT_ID');
    this.clientSecret = this.configService.get<string>('EXTENDEDREACH_CLIENT_SECRET');
  }

  async authenticate() {
    try {
      // Mock authentication - replace with actual ExtendedReach OAuth flow
      this.logger.log('Authenticating with ExtendedReach...');
      
      // In production, implement actual OAuth2 flow
      // const response = await firstValueFrom(
      //   this.httpService.post(`${this.baseUrl}/oauth/token`, {
      //     client_id: this.clientId,
      //     client_secret: this.clientSecret,
      //     grant_type: 'client_credentials',
      //   }),
      // );
      
      // this.accessToken = response.data.access_token;
      
      // For now, use a mock token
      this.accessToken = 'mock-access-token';
      
      this.logger.log('✅ Authenticated with ExtendedReach');
    } catch (error) {
      this.logger.error(`Failed to authenticate: ${error.message}`);
      throw error;
    }
  }

  async getClients(): Promise<any[]> {
    try {
      if (!this.accessToken) {
        await this.authenticate();
      }

      // Mock implementation - replace with actual API call
      this.logger.log('Fetching clients from ExtendedReach...');
      
      // In production:
      // const response = await firstValueFrom(
      //   this.httpService.get(`${this.baseUrl}/api/clients`, {
      //     headers: {
      //       Authorization: `Bearer ${this.accessToken}`,
      //     },
      //   }),
      // );
      
      // return response.data;

      // Mock data for development
      return [
        {
          id: 'er-client-1',
          firstName: 'John',
          lastName: 'Doe',
          dob: '1990-01-15',
          status: 'active',
        },
        {
          id: 'er-client-2',
          firstName: 'Jane',
          lastName: 'Smith',
          dob: '1985-05-20',
          status: 'active',
        },
      ];
    } catch (error) {
      this.logger.error(`Failed to fetch clients: ${error.message}`);
      return [];
    }
  }

  async getCases(): Promise<any[]> {
    try {
      if (!this.accessToken) {
        await this.authenticate();
      }

      this.logger.log('Fetching cases from ExtendedReach...');

      // Mock data for development
      return [
        {
          id: 'er-case-1',
          clientId: 'er-client-1',
          status: 'active',
          openedAt: '2024-01-01',
          closedAt: null,
        },
        {
          id: 'er-case-2',
          clientId: 'er-client-2',
          status: 'active',
          openedAt: '2024-02-15',
          closedAt: null,
        },
      ];
    } catch (error) {
      this.logger.error(`Failed to fetch cases: ${error.message}`);
      return [];
    }
  }

  async getActivities(): Promise<any[]> {
    try {
      if (!this.accessToken) {
        await this.authenticate();
      }

      this.logger.log('Fetching activities from ExtendedReach...');

      // Mock data for development
      return [
        {
          id: 'er-activity-1',
          caseId: 'er-case-1',
          type: 'home_visit',
          occurredAt: '2024-01-15',
          summary: 'Initial home visit completed',
        },
        {
          id: 'er-activity-2',
          caseId: 'er-case-1',
          type: 'phone_call',
          occurredAt: '2024-01-20',
          summary: 'Follow-up call with family',
        },
      ];
    } catch (error) {
      this.logger.error(`Failed to fetch activities: ${error.message}`);
      return [];
    }
  }

  async getServices(): Promise<any[]> {
    try {
      if (!this.accessToken) {
        await this.authenticate();
      }

      this.logger.log('Fetching services from ExtendedReach...');

      // Mock data for development
      return [];
    } catch (error) {
      this.logger.error(`Failed to fetch services: ${error.message}`);
      return [];
    }
  }
}

