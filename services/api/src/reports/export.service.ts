import { Injectable } from '@nestjs/common';
import * as ExcelJS from 'exceljs';
import { createObjectCsvWriter } from 'csv-writer';
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class ExportService {
  async exportToCSV(data: any[], filename: string): Promise<string> {
    if (!data || data.length === 0) {
      throw new Error('No data to export');
    }

    const headers = Object.keys(data[0]).map((key) => ({
      id: key,
      title: key.toUpperCase(),
    }));

    const filepath = path.join('/tmp', `${filename}.csv`);
    
    const csvWriter = createObjectCsvWriter({
      path: filepath,
      header: headers,
    });

    await csvWriter.writeRecords(data);

    return filepath;
  }

  async exportToExcel(data: any[], filename: string, sheetName = 'Report'): Promise<Buffer> {
    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet(sheetName);

    if (!data || data.length === 0) {
      throw new Error('No data to export');
    }

    // Add headers
    const headers = Object.keys(data[0]);
    worksheet.addRow(headers);

    // Style headers
    worksheet.getRow(1).font = { bold: true };
    worksheet.getRow(1).fill = {
      type: 'pattern',
      pattern: 'solid',
      fgColor: { argb: 'FFE0E0E0' },
    };

    // Add data rows
    data.forEach((row) => {
      const values = headers.map((header) => {
        const value = row[header];
        // Handle dates
        if (value instanceof Date) {
          return value.toISOString();
        }
        // Handle objects/arrays
        if (typeof value === 'object' && value !== null) {
          return JSON.stringify(value);
        }
        return value;
      });
      worksheet.addRow(values);
    });

    // Auto-fit columns
    worksheet.columns.forEach((column) => {
      let maxLength = 0;
      column.eachCell({ includeEmpty: true }, (cell) => {
        const columnLength = cell.value ? cell.value.toString().length : 10;
        if (columnLength > maxLength) {
          maxLength = columnLength;
        }
      });
      column.width = Math.min(maxLength + 2, 50);
    });

    // Generate buffer
    const buffer = await workbook.xlsx.writeBuffer();
    return Buffer.from(buffer);
  }

  flattenData(data: any[]): any[] {
    return data.map((item) => this.flattenObject(item));
  }

  private flattenObject(obj: any, prefix = ''): any {
    const flattened: any = {};

    Object.keys(obj).forEach((key) => {
      const value = obj[key];
      const newKey = prefix ? `${prefix}_${key}` : key;

      if (value === null || value === undefined) {
        flattened[newKey] = '';
      } else if (value instanceof Date) {
        flattened[newKey] = value.toISOString();
      } else if (typeof value === 'object' && !Array.isArray(value)) {
        // Recursively flatten nested objects
        Object.assign(flattened, this.flattenObject(value, newKey));
      } else if (Array.isArray(value)) {
        flattened[newKey] = JSON.stringify(value);
      } else {
        flattened[newKey] = value;
      }
    });

    return flattened;
  }
}

