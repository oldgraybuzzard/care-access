import { Injectable, NotFoundException, ForbiddenException, Logger, NotImplementedException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { StorageService } from '../storage/storage.service';
import { UploadDocumentDto } from './dto/upload-document.dto';

/**
 * TODO: Document service is temporarily disabled
 *
 * The Document model in the database uses the old vendor-based structure:
 * - vendorSourceId, vendorDocumentId, caseId, title, docType, metaJson
 *
 * This service was written for the new structure:
 * - organizationId, filename, storageKey, mimetype, size, category, etc.
 *
 * Need to either:
 * 1. Create a migration to update the documents table structure
 * 2. Rewrite this service to work with the current vendor-based structure
 *
 * For now, all methods throw NotImplementedException to allow the API to compile and run.
 */
@Injectable()
export class DocumentsService {
  private readonly logger = new Logger(DocumentsService.name);

  constructor(
    private prisma: PrismaService,
    private storage: StorageService,
  ) {}

  /**
   * Upload a document and save metadata to database
   * @deprecated Temporarily disabled - Document model migration needed
   */
  async uploadDocument(
    organizationId: string,
    userId: string,
    file: Express.Multer.File,
    dto: UploadDocumentDto,
  ) {
    this.logger.warn('Document upload is temporarily disabled - Document model migration needed');
    throw new NotImplementedException(
      'Document upload is temporarily disabled. The Document model needs to be migrated to the new structure.'
    );
  }

  /**
   * Get all documents for an organization (with optional filters)
   * @deprecated Temporarily disabled - Document model migration needed
   */
  async getDocuments(
    organizationId: string,
    filters?: {
      childId?: string;
      caseId?: string;
      clientId?: string;
      assessmentId?: string;
      category?: string;
    },
  ) {
    this.logger.warn('Document listing is temporarily disabled - Document model migration needed');
    // Return empty array instead of throwing error to allow UI to work
    return [];
  }

  /**
   * Get a single document by ID
   * @deprecated Temporarily disabled - Document model migration needed
   */
  async getDocument(organizationId: string, documentId: string) {
    this.logger.warn('Document retrieval is temporarily disabled - Document model migration needed');
    throw new NotFoundException('Document not found - Document service is temporarily disabled');
  }

  /**
   * Delete a document
   * @deprecated Temporarily disabled - Document model migration needed
   */
  async deleteDocument(organizationId: string, documentId: string) {
    this.logger.warn('Document deletion is temporarily disabled - Document model migration needed');
    throw new NotImplementedException(
      'Document deletion is temporarily disabled. The Document model needs to be migrated to the new structure.'
    );
  }
}

