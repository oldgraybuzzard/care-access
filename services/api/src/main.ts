import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);

  // Serve static files from uploads directory
  app.useStaticAssets(join(__dirname, '..', 'uploads'), {
    prefix: '/uploads/',
  });

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // CORS configuration
  // Allow localhost for development and specific origins from env var
  app.enableCors({
    origin: (origin, callback) => {
      // Allow requests with no origin (mobile apps, Postman, curl, etc.)
      if (!origin) {
        return callback(null, true);
      }

      // Always allow localhost and 127.0.0.1 for development
      if (
        origin.startsWith('http://localhost:') ||
        origin.startsWith('https://localhost:') ||
        origin.startsWith('http://127.0.0.1:') ||
        origin.startsWith('https://127.0.0.1:')
      ) {
        return callback(null, true);
      }

      // Check environment variable for additional allowed origins
      if (process.env.CORS_ORIGINS) {
        const allowedOrigins = process.env.CORS_ORIGINS.split(',').map((o) =>
          o.trim(),
        );
        if (allowedOrigins.includes(origin)) {
          return callback(null, true);
        }
      }

      // Log blocked origins for debugging
      console.warn(`⚠️  CORS blocked request from origin: ${origin}`);
      callback(null, false);
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
  });

  // Swagger/OpenAPI documentation
  const config = new DocumentBuilder()
    .setTitle('Care Access API')
    .setDescription('Comprehensive case management and reporting platform for care organizations')
    .setVersion('1.0')
    .addBearerAuth()
    .addTag('auth', 'Authentication endpoints')
    .addTag('search', 'Global search')
    .addTag('clients', 'Client management')
    .addTag('cases', 'Case management')
    .addTag('children', 'Children management')
    .addTag('reports', 'Reporting and exports')
    .addTag('dashboards', 'Dashboard and KPIs')
    .addTag('organizations', 'Organization management')
    .addTag('admin', 'Admin operations')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  const port = process.env.PORT || 3000;
  await app.listen(port, '0.0.0.0');

  console.log(`🚀 Care Access API running on port ${port}`);
  console.log(`📚 API Documentation available at /api`);
}

bootstrap();

