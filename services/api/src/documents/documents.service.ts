import { Injectable, NotFoundException, ForbiddenException, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { StorageService } from '../storage/storage.service';
import { UploadDocumentDto } from './dto/upload-document.dto';

@Injectable()
export class DocumentsService {
  private readonly logger = new Logger(DocumentsService.name);

  constructor(
    private prisma: PrismaService,
    private storage: StorageService,
  ) {}

  /**
   * Upload a document and save metadata to database
   */
  async uploadDocument(
    organizationId: string,
    userId: string,
    file: Express.Multer.File,
    dto: UploadDocumentDto,
  ) {
    this.logger.log(`Uploading document: ${file.originalname} for org: ${organizationId}`);

    // Determine folder based on category and entity
    let folder = `org-${organizationId}/${dto.category}`;
    if (dto.childId) folder += `/child-${dto.childId}`;
    else if (dto.caseId) folder += `/case-${dto.caseId}`;
    else if (dto.clientId) folder += `/client-${dto.clientId}`;
    else if (dto.assessmentId) folder += `/assessment-${dto.assessmentId}`;

    // Upload to R2
    const uploadResult = await this.storage.uploadFile({
      file: file.buffer,
      filename: file.originalname,
      mimetype: file.mimetype,
      folder,
      metadata: {
        organizationId,
        uploadedBy: userId,
        category: dto.category,
      },
    });

    // Save metadata to database
    const document = await this.prisma.document.create({
      data: {
        organizationId,
        filename: file.originalname,
        storageKey: uploadResult.key,
        mimetype: file.mimetype,
        size: uploadResult.size,
        category: dto.category,
        description: dto.description,
        tags: dto.tags || [],
        childId: dto.childId,
        caseId: dto.caseId,
        clientId: dto.clientId,
        assessmentId: dto.assessmentId,
        uploadedBy: userId,
      },
      include: {
        child: { select: { id: true, firstName: true, lastName: true } },
        case: { select: { id: true, status: true } },
        client: { select: { id: true, firstName: true, lastName: true } },
        assessment: { select: { id: true, assessmentType: true } },
      },
    });

    this.logger.log(`Document uploaded successfully: ${document.id}`);

    return {
      ...document,
      downloadUrl: uploadResult.url,
    };
  }

  /**
   * Get all documents for an organization (with optional filters)
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
    const documents = await this.prisma.document.findMany({
      where: {
        organizationId,
        ...filters,
      },
      include: {
        child: { select: { id: true, firstName: true, lastName: true } },
        case: { select: { id: true, status: true } },
        client: { select: { id: true, firstName: true, lastName: true } },
        assessment: { select: { id: true, assessmentType: true } },
      },
      orderBy: { uploadedAt: 'desc' },
    });

    // Generate signed URLs for each document
    const documentsWithUrls = await Promise.all(
      documents.map(async (doc) => ({
        ...doc,
        downloadUrl: await this.storage.getSignedUrl(doc.storageKey, 3600),
      })),
    );

    return documentsWithUrls;
  }

  /**
   * Get a single document by ID
   */
  async getDocument(organizationId: string, documentId: string) {
    const document = await this.prisma.document.findFirst({
      where: {
        id: documentId,
        organizationId,
      },
      include: {
        child: { select: { id: true, firstName: true, lastName: true } },
        case: { select: { id: true, status: true } },
        client: { select: { id: true, firstName: true, lastName: true } },
        assessment: { select: { id: true, assessmentType: true } },
      },
    });

    if (!document) {
      throw new NotFoundException('Document not found');
    }

    // Generate signed URL
    const downloadUrl = await this.storage.getSignedUrl(document.storageKey, 3600);

    return {
      ...document,
      downloadUrl,
    };
  }

  /**
   * Delete a document
   */
  async deleteDocument(organizationId: string, documentId: string) {
    const document = await this.prisma.document.findFirst({
      where: {
        id: documentId,
        organizationId,
      },
    });

    if (!document) {
      throw new NotFoundException('Document not found');
    }

    // Delete from R2
    await this.storage.deleteFile(document.storageKey);

    // Delete from database
    await this.prisma.document.delete({
      where: { id: documentId },
    });

    this.logger.log(`Document deleted: ${documentId}`);

    return { message: 'Document deleted successfully' };
  }
}

