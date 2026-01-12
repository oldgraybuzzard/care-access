import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';
import { PrismaService } from '../src/prisma/prisma.service';

describe('Tenant Isolation (e2e)', () => {
  let app: INestApplication;
  let prisma: PrismaService;
  let org1Token: string;
  let org2Token: string;
  let org1ChildId: string;
  let org2ChildId: string;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();

    prisma = app.get<PrismaService>(PrismaService);

    // Login as org1 user
    const org1Response = await request(app.getHttpServer())
      .post('/auth/login')
      .send({
        email: 'admin@fcf.org',
        password: 'password123',
      });
    org1Token = org1Response.body.accessToken;

    // Login as org2 user
    const org2Response = await request(app.getHttpServer())
      .post('/auth/login')
      .send({
        email: 'admin@hope.org',
        password: 'password123',
      });
    org2Token = org2Response.body.accessToken;

    // Get child IDs for testing
    const org1Children = await prisma.child.findMany({
      where: { organizationId: 'fcf-default-org-id' },
      take: 1,
    });
    org1ChildId = org1Children[0]?.id;

    const org2Children = await prisma.child.findMany({
      where: { organization: { slug: 'hope' } },
      take: 1,
    });
    org2ChildId = org2Children[0]?.id;
  });

  afterAll(async () => {
    await app.close();
  });

  describe('Children API', () => {
    it('should only return children from org1 when logged in as org1', async () => {
      const response = await request(app.getHttpServer())
        .get('/children')
        .set('Authorization', `Bearer ${org1Token}`)
        .expect(200);

      expect(response.body).toBeInstanceOf(Array);
      expect(response.body.length).toBeGreaterThan(0);
      
      // All children should belong to org1
      response.body.forEach((child: any) => {
        expect(child.organizationId).toBe('fcf-default-org-id');
      });
    });

    it('should only return children from org2 when logged in as org2', async () => {
      const response = await request(app.getHttpServer())
        .get('/children')
        .set('Authorization', `Bearer ${org2Token}`)
        .expect(200);

      expect(response.body).toBeInstanceOf(Array);
      expect(response.body.length).toBeGreaterThan(0);
      
      // All children should belong to org2
      response.body.forEach((child: any) => {
        expect(child.organizationId).not.toBe('fcf-default-org-id');
      });
    });

    it('should not allow org1 to access org2 child', async () => {
      if (!org2ChildId) {
        console.warn('Skipping test: No org2 child found');
        return;
      }

      await request(app.getHttpServer())
        .get(`/children/${org2ChildId}`)
        .set('Authorization', `Bearer ${org1Token}`)
        .expect(404); // Should not find the child
    });

    it('should not allow org2 to access org1 child', async () => {
      if (!org1ChildId) {
        console.warn('Skipping test: No org1 child found');
        return;
      }

      await request(app.getHttpServer())
        .get(`/children/${org1ChildId}`)
        .set('Authorization', `Bearer ${org2Token}`)
        .expect(404); // Should not find the child
    });

    it('should create child in correct organization', async () => {
      const response = await request(app.getHttpServer())
        .post('/children')
        .set('Authorization', `Bearer ${org1Token}`)
        .send({
          firstName: 'Test',
          lastName: 'Child',
          dateOfBirth: '2015-01-01',
          gender: 'Male',
          status: 'Active',
        })
        .expect(201);

      expect(response.body.organizationId).toBe('fcf-default-org-id');
      
      // Cleanup
      await prisma.child.delete({ where: { id: response.body.id } });
    });

    it('should not allow updating child from another organization', async () => {
      if (!org2ChildId) {
        console.warn('Skipping test: No org2 child found');
        return;
      }

      await request(app.getHttpServer())
        .patch(`/children/${org2ChildId}`)
        .set('Authorization', `Bearer ${org1Token}`)
        .send({
          firstName: 'Hacked',
        })
        .expect(404); // Should not find the child
    });

    it('should not allow deleting child from another organization', async () => {
      if (!org2ChildId) {
        console.warn('Skipping test: No org2 child found');
        return;
      }

      await request(app.getHttpServer())
        .delete(`/children/${org2ChildId}`)
        .set('Authorization', `Bearer ${org1Token}`)
        .expect(404); // Should not find the child
    });
  });
});

