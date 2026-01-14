import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  S3Client,
  PutObjectCommand,
  GetObjectCommand,
  DeleteObjectCommand,
  HeadObjectCommand,
  ListObjectsV2Command,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { randomUUID } from 'crypto';

export interface UploadFileDto {
  file: Buffer;
  filename: string;
  mimetype: string;
  folder?: string;
  metadata?: Record<string, string>;
}

export interface UploadResult {
  key: string;
  url: string;
  size: number;
  mimetype: string;
}

@Injectable()
export class StorageService {
  private readonly logger = new Logger(StorageService.name);
  private readonly s3Client: S3Client;
  private readonly bucketName: string;
  private readonly accountId: string;

  // Allowed file types for security
  private readonly ALLOWED_MIMETYPES = [
    // Images
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/webp',
    // Documents
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'text/csv',
    'text/plain',
    // Archives
    'application/zip',
  ];

  // Max file size: 50MB
  private readonly MAX_FILE_SIZE = 50 * 1024 * 1024;

  constructor(private configService: ConfigService) {
    this.accountId = this.configService.get<string>('R2_ACCOUNT_ID');
    this.bucketName = this.configService.get<string>('R2_BUCKET_NAME');
    const accessKeyId = this.configService.get<string>('R2_ACCESS_KEY_ID');
    const secretAccessKey = this.configService.get<string>('R2_SECRET_ACCESS_KEY');
    const s3Url = this.configService.get<string>('R2_S3_URL');

    if (!this.accountId || !this.bucketName || !accessKeyId || !secretAccessKey || !s3Url) {
      throw new Error('Missing required R2 configuration. Please check environment variables.');
    }

    this.s3Client = new S3Client({
      region: 'auto',
      endpoint: s3Url,
      credentials: {
        accessKeyId,
        secretAccessKey,
      },
    });

    this.logger.log(`Storage service initialized with bucket: ${this.bucketName}`);
  }

  /**
   * Upload a file to R2 storage
   */
  async uploadFile(dto: UploadFileDto): Promise<UploadResult> {
    // Validate file size
    if (dto.file.length > this.MAX_FILE_SIZE) {
      throw new BadRequestException(
        `File size exceeds maximum allowed size of ${this.MAX_FILE_SIZE / 1024 / 1024}MB`,
      );
    }

    // Validate mimetype
    if (!this.ALLOWED_MIMETYPES.includes(dto.mimetype)) {
      throw new BadRequestException(
        `File type ${dto.mimetype} is not allowed. Allowed types: ${this.ALLOWED_MIMETYPES.join(', ')}`,
      );
    }

    // Generate unique key
    const fileExtension = dto.filename.split('.').pop();
    const uniqueFilename = `${randomUUID()}.${fileExtension}`;
    const key = dto.folder ? `${dto.folder}/${uniqueFilename}` : uniqueFilename;

    try {
      // Upload to R2
      await this.s3Client.send(
        new PutObjectCommand({
          Bucket: this.bucketName,
          Key: key,
          Body: dto.file,
          ContentType: dto.mimetype,
          Metadata: dto.metadata || {},
        }),
      );

      this.logger.log(`File uploaded successfully: ${key}`);

      // Generate signed URL (valid for 1 hour)
      const url = await this.getSignedUrl(key, 3600);

      return {
        key,
        url,
        size: dto.file.length,
        mimetype: dto.mimetype,
      };
    } catch (error) {
      this.logger.error(`Failed to upload file: ${error.message}`, error.stack);
      throw new BadRequestException('Failed to upload file');
    }
  }

  /**
   * Generate a signed URL for downloading a file
   * @param key - The file key in R2
   * @param expiresIn - URL expiration time in seconds (default: 1 hour)
   */
  async getSignedUrl(key: string, expiresIn: number = 3600): Promise<string> {
    try {
      const command = new GetObjectCommand({
        Bucket: this.bucketName,
        Key: key,
      });

      const url = await getSignedUrl(this.s3Client, command, { expiresIn });
      return url;
    } catch (error) {
      this.logger.error(`Failed to generate signed URL: ${error.message}`, error.stack);
      throw new BadRequestException('Failed to generate download URL');
    }
  }

  /**
   * Delete a file from R2 storage
   */
  async deleteFile(key: string): Promise<void> {
    try {
      await this.s3Client.send(
        new DeleteObjectCommand({
          Bucket: this.bucketName,
          Key: key,
        }),
      );

      this.logger.log(`File deleted successfully: ${key}`);
    } catch (error) {
      this.logger.error(`Failed to delete file: ${error.message}`, error.stack);
      throw new BadRequestException('Failed to delete file');
    }
  }
}

