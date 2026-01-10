import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // CORS configuration
  // In production, use environment variable. In development, allow all localhost
  const isProduction = process.env.NODE_ENV === 'production';

  if (isProduction && process.env.CORS_ORIGINS) {
    // Production: Use specific origins from environment variable
    app.enableCors({
      origin: process.env.CORS_ORIGINS.split(','),
      credentials: true,
      methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
    });
  } else {
    // Development: Allow all localhost origins and requests with no origin
    app.enableCors({
      origin: (origin, callback) => {
        // Allow requests with no origin (mobile apps, Postman, etc.)
        if (!origin) {
          return callback(null, true);
        }

        // Allow all localhost origins for development
        if (origin.startsWith('http://localhost:') || origin.startsWith('http://127.0.0.1:')) {
          return callback(null, true);
        }

        // Log and block other origins in development
        console.warn(`⚠️  CORS blocked request from origin: ${origin}`);
        callback(null, false);
      },
      credentials: true,
      methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
    });
  }

  // Swagger/OpenAPI documentation
  const config = new DocumentBuilder()
    .setTitle('FCF Platform API')
    .setDescription('Friends of Children and Families - ExtendedReach Reporting API')
    .setVersion('1.0')
    .addBearerAuth()
    .addTag('auth', 'Authentication endpoints')
    .addTag('search', 'Global search')
    .addTag('clients', 'Client management')
    .addTag('cases', 'Case management')
    .addTag('reports', 'Reporting and exports')
    .addTag('dashboards', 'Dashboard and KPIs')
    .addTag('admin', 'Admin operations')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  const port = process.env.PORT || 3000;
  await app.listen(port, '0.0.0.0');

  console.log(`🚀 FCF Platform API running on port ${port}`);
  console.log(`📚 API Documentation available at /api`);
}

bootstrap();

