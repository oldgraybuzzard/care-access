import {
  Controller,
  Post,
  Get,
  Delete,
  Param,
  Query,
  Body,
  UseInterceptors,
  UploadedFile,
  UseGuards,
  Req,
  ParseFilePipe,
  MaxFileSizeValidator,
  FileTypeValidator,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiTags, ApiOperation, ApiConsumes, ApiBody, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { DocumentsService } from './documents.service';
import { UploadDocumentDto, DocumentCategory } from './dto/upload-document.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('documents')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('documents')
export class DocumentsController {
  constructor(private readonly documentsService: DocumentsService) {}

  @Post('upload')
  @ApiOperation({ summary: 'Upload a document' })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: {
          type: 'string',
          format: 'binary',
        },
        category: {
          type: 'string',
          enum: Object.values(DocumentCategory),
        },
        description: { type: 'string' },
        tags: { type: 'array', items: { type: 'string' } },
        childId: { type: 'string', format: 'uuid' },
        caseId: { type: 'string', format: 'uuid' },
        clientId: { type: 'string', format: 'uuid' },
        assessmentId: { type: 'string', format: 'uuid' },
      },
      required: ['file', 'category'],
    },
  })
  @UseInterceptors(FileInterceptor('file'))
  async uploadDocument(
    @Req() req: any,
    @UploadedFile(
      new ParseFilePipe({
        validators: [
          new MaxFileSizeValidator({ maxSize: 50 * 1024 * 1024 }), // 50MB
          new FileTypeValidator({
            fileType: /(jpg|jpeg|png|gif|webp|pdf|doc|docx|xls|xlsx|csv|txt|zip)$/,
          }),
        ],
      }),
    )
    file: Express.Multer.File,
    @Body() dto: UploadDocumentDto,
  ) {
    const organizationId = req.user.organizationId;
    const userId = req.user.userId;

    return this.documentsService.uploadDocument(organizationId, userId, file, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all documents (with optional filters)' })
  @ApiQuery({ name: 'childId', required: false, type: String })
  @ApiQuery({ name: 'caseId', required: false, type: String })
  @ApiQuery({ name: 'clientId', required: false, type: String })
  @ApiQuery({ name: 'assessmentId', required: false, type: String })
  @ApiQuery({ name: 'category', required: false, enum: DocumentCategory })
  async getDocuments(
    @Req() req: any,
    @Query('childId') childId?: string,
    @Query('caseId') caseId?: string,
    @Query('clientId') clientId?: string,
    @Query('assessmentId') assessmentId?: string,
    @Query('category') category?: string,
  ) {
    const organizationId = req.user.organizationId;

    return this.documentsService.getDocuments(organizationId, {
      childId,
      caseId,
      clientId,
      assessmentId,
      category,
    });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get a single document by ID' })
  async getDocument(@Req() req: any, @Param('id') id: string) {
    const organizationId = req.user.organizationId;
    return this.documentsService.getDocument(organizationId, id);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete a document' })
  async deleteDocument(@Req() req: any, @Param('id') id: string) {
    const organizationId = req.user.organizationId;
    return this.documentsService.deleteDocument(organizationId, id);
  }
}

