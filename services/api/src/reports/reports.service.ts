import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { RunReportDto } from './dto/run-report.dto';
import { RunCustomReportDto } from './dto/run-custom-report.dto';

@Injectable()
export class ReportsService {
  constructor(private prisma: PrismaService) {}

  // Get all report definitions
  async getDefinitions(organizationId: string) {
    return this.prisma.reportDefinition.findMany({
      where: {
        organizationId,
        OR: [
          { type: 'standard' },
          { isShared: true },
        ],
      },
      orderBy: {
        name: 'asc',
      },
    });
  }

  // Run a standard report
  async runStandardReport(dto: RunReportDto, userId: string, organizationId: string) {
    const definition = await this.prisma.reportDefinition.findUnique({
      where: { id: dto.reportDefinitionId },
    });

    if (!definition) {
      throw new NotFoundException('Report definition not found');
    }

    // Verify the report belongs to the user's organization
    if (definition.organizationId !== organizationId) {
      throw new NotFoundException('Report definition not found');
    }

    // Create report run record
    const reportRun = await this.prisma.reportRun.create({
      data: {
        reportDefinitionId: dto.reportDefinitionId,
        requestedBy: userId,
        status: 'running',
        metaJson: dto.filters || {},
      },
    });

    try {
      // Execute the report based on type
      let data: any[];

      switch (definition.name) {
        case 'Caseload by Worker':
          data = await this.getCaseloadByWorker(organizationId, dto.filters);
          break;
        case 'Active Cases by Program/Status':
          data = await this.getActiveCasesByProgramStatus(organizationId, dto.filters);
          break;
        case 'Intakes vs Closures Trend':
          data = await this.getIntakesVsClosuresTrend(organizationId, dto.filters);
          break;
        case 'Overdue/Compliance List':
          data = await this.getOverdueComplianceList(organizationId, dto.filters);
          break;
        case 'Services Delivered by Period':
          data = await this.getServicesDeliveredByPeriod(organizationId, dto.filters);
          break;
        default:
          throw new BadRequestException('Unknown report type');
      }

      // Update report run with results
      await this.prisma.reportRun.update({
        where: { id: reportRun.id },
        data: {
          status: 'completed',
          finishedAt: new Date(),
          rowCount: data.length,
        },
      });

      return {
        reportRunId: reportRun.id,
        data,
        rowCount: data.length,
      };
    } catch (error) {
      // Update report run with error
      await this.prisma.reportRun.update({
        where: { id: reportRun.id },
        data: {
          status: 'failed',
          finishedAt: new Date(),
          metaJson: { error: error.message },
        },
      });

      throw error;
    }
  }

  // Run a custom report
  async runCustomReport(dto: RunCustomReportDto, userId: string, organizationId: string) {
    // Create report run record
    const reportRun = await this.prisma.reportRun.create({
      data: {
        reportDefinitionId: dto.reportDefinitionId || null,
        requestedBy: userId,
        status: 'running',
        metaJson: dto as any,
      },
    });

    try {
      let data: any[];

      switch (dto.dataset) {
        case 'clients':
          data = await this.queryClients(dto, organizationId);
          break;
        case 'cases':
          data = await this.queryCases(dto, organizationId);
          break;
        case 'activities':
          data = await this.queryActivities(dto, organizationId);
          break;
        case 'services':
          data = await this.queryServices(dto, organizationId);
          break;
        case 'children':
          data = await this.queryChildren(dto, organizationId);
          break;
        case 'education':
          data = await this.queryEducation(dto, organizationId);
          break;
        case 'behavioral_incidents':
          data = await this.queryBehavioralIncidents(dto, organizationId);
          break;
        case 'goals':
          data = await this.queryGoals(dto, organizationId);
          break;
        case 'assessments':
          data = await this.queryAssessments(dto, organizationId);
          break;
        case 'medical_records':
          data = await this.queryMedicalRecords(dto, organizationId);
          break;
        case 'home_visits':
          data = await this.queryHomeVisits(dto, organizationId);
          break;
        case 'families':
          data = await this.queryFamilies(dto, organizationId);
          break;
        default:
          throw new BadRequestException('Invalid dataset');
      }

      // Update report run with results
      await this.prisma.reportRun.update({
        where: { id: reportRun.id },
        data: {
          status: 'completed',
          finishedAt: new Date(),
          rowCount: data.length,
        },
      });

      return {
        reportRunId: reportRun.id,
        data,
        rowCount: data.length,
      };
    } catch (error) {
      await this.prisma.reportRun.update({
        where: { id: reportRun.id },
        data: {
          status: 'failed',
          finishedAt: new Date(),
          metaJson: { error: error.message },
        },
      });

      throw error;
    }
  }

  // Get report run results
  async getReportRunResults(runId: string, page = 1, limit = 100) {
    const reportRun = await this.prisma.reportRun.findUnique({
      where: { id: runId },
      include: {
        reportDefinition: true,
      },
    });

    if (!reportRun) {
      throw new NotFoundException('Report run not found');
    }

    // In a production system, you'd store results in a separate table or cache
    // For now, we'll return the metadata
    return {
      reportRun,
      message: 'Results are available for export',
    };
  }

  // Standard Report Implementations
  private async getCaseloadByWorker(organizationId: string, filters: any) {
    return this.prisma.case.groupBy({
      by: ['assignedWorkerId'],
      where: {
        organizationId,
        status: 'active',
        ...(filters?.programId && { programId: filters.programId }),
      },
      _count: {
        id: true,
      },
    });
  }

  private async getActiveCasesByProgramStatus(organizationId: string, filters: any) {
    return this.prisma.case.groupBy({
      by: ['programId', 'status'],
      where: {
        organizationId,
        ...(filters?.programId && { programId: filters.programId }),
      },
      _count: {
        id: true,
      },
    });
  }

  private async getIntakesVsClosuresTrend(organizationId: string, filters: any): Promise<any[]> {
    // This would typically use KpiDaily table for better performance
    const startDate = filters?.startDate ? new Date(filters.startDate) : new Date(new Date().setMonth(new Date().getMonth() - 6));
    const endDate = filters?.endDate ? new Date(filters.endDate) : new Date();

    const result = await this.prisma.$queryRaw`
      SELECT
        DATE_TRUNC('month', opened_at) as month,
        COUNT(*) FILTER (WHERE opened_at IS NOT NULL) as intakes,
        COUNT(*) FILTER (WHERE closed_at IS NOT NULL) as closures
      FROM cases
      WHERE organization_id = ${organizationId}
        AND opened_at >= ${startDate} AND opened_at <= ${endDate}
      GROUP BY month
      ORDER BY month
    `;

    return result as any[];
  }

  private async getOverdueComplianceList(organizationId: string, filters: any) {
    // Placeholder - would need business logic for "overdue" definition
    return this.prisma.case.findMany({
      where: {
        organizationId,
        status: 'active',
        // Add overdue logic here based on business rules
      },
      include: {
        client: true,
        worker: true,
        program: true,
      },
    });
  }

  private async getServicesDeliveredByPeriod(organizationId: string, filters: any) {
    const startDate = filters?.startDate ? new Date(filters.startDate) : new Date(new Date().setMonth(new Date().getMonth() - 1));
    const endDate = filters?.endDate ? new Date(filters.endDate) : new Date();

    // Service doesn't have organizationId, so we need to filter through Case
    return this.prisma.service.groupBy({
      by: ['serviceType'],
      where: {
        case: {
          organizationId,
        },
        startAt: {
          gte: startDate,
          lte: endDate,
        },
      },
      _count: {
        id: true,
      },
    });
  }

  // Custom Report Query Methods
  private async queryClients(dto: RunCustomReportDto, organizationId: string) {
    const where: any = {
      organizationId,
    };

    if (dto.filters?.programId) {
      where.programId = dto.filters.programId;
    }

    if (dto.filters?.status) {
      where.status = dto.filters.status;
    }

    return this.prisma.client.findMany({
      where,
      include: {
        program: true,
      },
    });
  }

  private async queryCases(dto: RunCustomReportDto, organizationId: string) {
    const where: any = {
      organizationId,
    };

    if (dto.filters?.programId) {
      where.programId = dto.filters.programId;
    }

    if (dto.filters?.status) {
      where.status = dto.filters.status;
    }

    if (dto.filters?.workerId) {
      where.assignedWorkerId = dto.filters.workerId;
    }

    if (dto.filters?.startDate || dto.filters?.endDate) {
      where.openedAt = {};
      if (dto.filters.startDate) {
        where.openedAt.gte = new Date(dto.filters.startDate);
      }
      if (dto.filters.endDate) {
        where.openedAt.lte = new Date(dto.filters.endDate);
      }
    }

    return this.prisma.case.findMany({
      where,
      include: {
        client: true,
        worker: true,
        program: true,
      },
    });
  }

  private async queryActivities(dto: RunCustomReportDto, organizationId: string) {
    const where: any = {
      case: {
        organizationId,
      },
    };

    if (dto.filters?.activityType) {
      where.activityType = dto.filters.activityType;
    }

    if (dto.filters?.startDate || dto.filters?.endDate) {
      where.occurredAt = {};
      if (dto.filters.startDate) {
        where.occurredAt.gte = new Date(dto.filters.startDate);
      }
      if (dto.filters.endDate) {
        where.occurredAt.lte = new Date(dto.filters.endDate);
      }
    }

    return this.prisma.activity.findMany({
      where,
      include: {
        case: {
          include: {
            client: true,
          },
        },
      },
    });
  }

  private async queryServices(dto: RunCustomReportDto, organizationId: string) {
    const where: any = {
      case: {
        organizationId,
      },
    };

    if (dto.filters?.serviceType) {
      where.serviceType = dto.filters.serviceType;
    }

    if (dto.filters?.startDate || dto.filters?.endDate) {
      where.startAt = {};
      if (dto.filters.startDate) {
        where.startAt.gte = new Date(dto.filters.startDate);
      }
      if (dto.filters.endDate) {
        where.startAt.lte = new Date(dto.filters.endDate);
      }
    }

    return this.prisma.service.findMany({
      where,
      include: {
        case: {
          include: {
            client: true,
          },
        },
      },
    });
  }

  private async queryChildren(dto: RunCustomReportDto, organizationId: string) {
    const where: any = {
      organizationId,
    };

    if (dto.filters?.status) {
      where.status = dto.filters.status;
    }

    if (dto.filters?.gender) {
      where.gender = dto.filters.gender;
    }

    if (dto.filters?.ageMin || dto.filters?.ageMax) {
      const now = new Date();
      where.dateOfBirth = {};

      if (dto.filters.ageMax) {
        const minDate = new Date(now.getFullYear() - dto.filters.ageMax - 1, now.getMonth(), now.getDate());
        where.dateOfBirth.gte = minDate;
      }

      if (dto.filters.ageMin) {
        const maxDate = new Date(now.getFullYear() - dto.filters.ageMin, now.getMonth(), now.getDate());
        where.dateOfBirth.lte = maxDate;
      }
    }

    return this.prisma.child.findMany({
      where,
      include: {
        family: true,
        educationRecords: {
          orderBy: { schoolYear: 'desc' },
          take: 1,
        },
      },
    });
  }

  private async queryEducation(dto: RunCustomReportDto, organizationId: string) {
    const where: any = {
      organizationId,
    };

    if (dto.filters?.childId) {
      where.childId = dto.filters.childId;
    }

    if (dto.filters?.schoolYear) {
      where.schoolYear = dto.filters.schoolYear;
    }

    if (dto.filters?.gradeLevel) {
      where.gradeLevel = dto.filters.gradeLevel;
    }

    if (dto.filters?.hasIep !== undefined) {
      where.hasIep = dto.filters.hasIep;
    }

    if (dto.filters?.has504Plan !== undefined) {
      where.has504Plan = dto.filters.has504Plan;
    }

    if (dto.filters?.gpaMin || dto.filters?.gpaMax) {
      where.gpa = {};
      if (dto.filters.gpaMin) {
        where.gpa.gte = dto.filters.gpaMin;
      }
      if (dto.filters.gpaMax) {
        where.gpa.lte = dto.filters.gpaMax;
      }
    }

    return this.prisma.educationRecord.findMany({
      where,
      include: {
        child: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            dateOfBirth: true,
          },
        },
      },
      orderBy: {
        schoolYear: 'desc',
      },
    });
  }

  private async queryBehavioralIncidents(dto: RunCustomReportDto, organizationId: string) {
    const where: any = {
      organizationId,
    };

    if (dto.filters?.childId) {
      where.childId = dto.filters.childId;
    }

    if (dto.filters?.incidentType) {
      where.incidentType = dto.filters.incidentType;
    }

    if (dto.filters?.severityLevel) {
      where.severityLevel = dto.filters.severityLevel;
    }

    if (dto.filters?.startDate || dto.filters?.endDate) {
      where.incidentDate = {};
      if (dto.filters.startDate) {
        where.incidentDate.gte = new Date(dto.filters.startDate);
      }
      if (dto.filters.endDate) {
        where.incidentDate.lte = new Date(dto.filters.endDate);
      }
    }

    return this.prisma.behavioralIncident.findMany({
      where,
      include: {
        child: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
          },
        },
      },
      orderBy: {
        incidentDate: 'desc',
      },
    });
  }

  private async queryGoals(dto: RunCustomReportDto, organizationId: string) {
    const where: any = {
      organizationId,
    };

    if (dto.filters?.childId) {
      where.childId = dto.filters.childId;
    }

    if (dto.filters?.goalCategory) {
      where.goalCategory = dto.filters.goalCategory;
    }

    if (dto.filters?.goalStatus) {
      where.status = dto.filters.goalStatus;
    }

    return this.prisma.goal.findMany({
      where,
      include: {
        child: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
          },
        },
        progress: {
          orderBy: { progressDate: 'desc' },
          take: 5,
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
    });
  }

  private async queryAssessments(dto: RunCustomReportDto, organizationId: string) {
    const where: any = {
      organizationId,
    };

    if (dto.filters?.childId) {
      where.childId = dto.filters.childId;
    }

    if (dto.filters?.startDate || dto.filters?.endDate) {
      where.assessmentDate = {};
      if (dto.filters.startDate) {
        where.assessmentDate.gte = new Date(dto.filters.startDate);
      }
      if (dto.filters.endDate) {
        where.assessmentDate.lte = new Date(dto.filters.endDate);
      }
    }

    return this.prisma.assessment.findMany({
      where,
      include: {
        child: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
          },
        },
      },
      orderBy: {
        assessmentDate: 'desc',
      },
    });
  }

  private async queryMedicalRecords(dto: RunCustomReportDto, organizationId: string) {
    const where: any = {
      organizationId,
    };

    if (dto.filters?.childId) {
      where.childId = dto.filters.childId;
    }

    if (dto.filters?.startDate || dto.filters?.endDate) {
      where.appointmentDate = {};
      if (dto.filters.startDate) {
        where.appointmentDate.gte = new Date(dto.filters.startDate);
      }
      if (dto.filters.endDate) {
        where.appointmentDate.lte = new Date(dto.filters.endDate);
      }
    }

    return this.prisma.medicalRecord.findMany({
      where,
      include: {
        child: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
          },
        },
      },
      orderBy: {
        appointmentDate: 'desc',
      },
    });
  }

  private async queryHomeVisits(dto: RunCustomReportDto, organizationId: string) {
    const where: any = {
      organizationId,
    };

    if (dto.filters?.childId) {
      where.childId = dto.filters.childId;
    }

    if (dto.filters?.startDate || dto.filters?.endDate) {
      where.visitDate = {};
      if (dto.filters.startDate) {
        where.visitDate.gte = new Date(dto.filters.startDate);
      }
      if (dto.filters.endDate) {
        where.visitDate.lte = new Date(dto.filters.endDate);
      }
    }

    return this.prisma.homeVisit.findMany({
      where,
      include: {
        child: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
          },
        },
      },
      orderBy: {
        visitDate: 'desc',
      },
    });
  }

  private async queryFamilies(dto: RunCustomReportDto, organizationId: string) {
    const where: any = {
      organizationId,
    };

    if (dto.filters?.status) {
      where.status = dto.filters.status;
    }

    return this.prisma.family.findMany({
      where,
      include: {
        children: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            status: true,
          },
        },
      },
    });
  }
}

