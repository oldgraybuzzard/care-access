import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  console.log('🔧 FCF Platform Worker Service starting...');
  console.log(`📅 Sync interval: ${process.env.SYNC_INTERVAL_MINUTES || 60} minutes`);

  await app.init();

  console.log('✅ Worker service is running');
}

bootstrap();

