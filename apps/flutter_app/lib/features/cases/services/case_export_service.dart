import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import '../../../core/models/case.dart';

class CaseExportService {
  /// Export case details to PDF
  Future<void> exportToPdf(CaseDetail caseDetail) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Case Details: ${caseDetail.vendorCaseId}',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            _buildPdfSection('Case Information', [
              'Case ID: ${caseDetail.vendorCaseId}',
              'Status: ${caseDetail.status}',
              'Opened: ${DateFormat('MMM d, yyyy').format(caseDetail.openedAt)}',
              if (caseDetail.closedAt != null)
                'Closed: ${DateFormat('MMM d, yyyy').format(caseDetail.closedAt!)}',
            ]),
            pw.SizedBox(height: 20),
            if (caseDetail.client != null) ...[
              _buildPdfSection('Client Information', [
                'Name: ${caseDetail.client!.fullName}',
                'Status: ${caseDetail.client!.status}',
                if (caseDetail.client!.dob != null)
                  'Date of Birth: ${DateFormat('MMM d, yyyy').format(caseDetail.client!.dob!)}',
              ]),
              pw.SizedBox(height: 20),
            ],
            if (caseDetail.worker != null) ...[
              _buildPdfSection('Assigned Worker', [
                'Name: ${caseDetail.worker!.name}',
                if (caseDetail.worker!.email != null)
                  'Email: ${caseDetail.worker!.email}',
              ]),
              pw.SizedBox(height: 20),
            ],
            if (caseDetail.program != null) ...[
              _buildPdfSection('Program', [
                'Name: ${caseDetail.program!.name}',
              ]),
            ],
          ];
        },
      ),
    );

    // Show print dialog
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildPdfSection(String title, List<String> items) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        ...items.map(
          (item) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 5),
            child: pw.Text(item),
          ),
        ),
      ],
    );
  }

  /// Export activities to CSV
  Future<void> exportActivitiesToCsv(
    String caseId,
    List<Activity> activities,
  ) async {
    final List<List<dynamic>> rows = [
      ['Date', 'Type', 'Summary'],
    ];

    for (final activity in activities) {
      rows.add([
        DateFormat('yyyy-MM-dd HH:mm').format(activity.occurredAt),
        activity.activityType,
        activity.summary ?? '',
      ]);
    }

    final String csv = const ListToCsvConverter().convert(rows);

    // Get downloads directory
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/case_${caseId}_activities.csv');
    await file.writeAsString(csv);

    // Note: In a real app, you'd want to share this file or show a success message
    print('CSV exported to: ${file.path}');
  }

  /// Export services to CSV
  Future<void> exportServicesToCsv(
    String caseId,
    List<Service> services,
  ) async {
    final List<List<dynamic>> rows = [
      ['Service Type', 'Start Date', 'End Date', 'Status'],
    ];

    for (final service in services) {
      rows.add([
        service.serviceType,
        DateFormat('yyyy-MM-dd').format(service.startAt),
        service.endAt != null
            ? DateFormat('yyyy-MM-dd').format(service.endAt!)
            : 'Ongoing',
        service.isActive ? 'Active' : 'Inactive',
      ]);
    }

    final String csv = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/case_${caseId}_services.csv');
    await file.writeAsString(csv);

    print('CSV exported to: ${file.path}');
  }
}
