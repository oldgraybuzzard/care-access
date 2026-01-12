import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateEducationRecordDto } from './dto/create-education-record.dto';
import { UpdateEducationRecordDto } from './dto/update-education-record.dto';

@Injectable()
export class EducationRecordsService {
  constructor(private prisma: PrismaService) {}

  async create(childId: string, createEducationRecordDto: CreateEducationRecordDto) {
    // Verify child exists
    const child = await this.prisma.child.findUnique({
      where: { id: childId },
    });

    if (!child) {
      throw new NotFoundException(`Child with ID ${childId} not found`);
    }

    return this.prisma.educationRecord.create({
      data: {
        childId,
        ...createEducationRecordDto,
      },
    });
  }

  async findAll(childId: string) {
    return this.prisma.educationRecord.findMany({
      where: { childId },
      orderBy: { schoolYear: 'desc' },
    });
  }

  async findOne(id: string) {
    const record = await this.prisma.educationRecord.findUnique({
      where: { id },
      include: {
        child: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
          },
        },
      },
    });

    if (!record) {
      throw new NotFoundException(`Education record with ID ${id} not found`);
    }

    return record;
  }

  async update(id: string, updateEducationRecordDto: UpdateEducationRecordDto) {
    // Verify record exists
    await this.findOne(id);

    return this.prisma.educationRecord.update({
      where: { id },
      data: updateEducationRecordDto,
    });
  }

  async remove(id: string) {
    // Verify record exists
    await this.findOne(id);

    return this.prisma.educationRecord.delete({
      where: { id },
    });
  }
}

