import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fcf_app/core/models/case.dart';
import 'package:fcf_app/features/cases/presentation/case_detail_screen.dart';
import 'package:fcf_app/features/cases/providers/case_provider.dart';

void main() {
  group('CaseDetailScreen', () {
    late CaseDetail mockCaseDetail;

    setUp(() {
      mockCaseDetail = CaseDetail(
        id: 'case-123',
        vendorSourceId: 'vendor-1',
        vendorCaseId: 'VC-001',
        clientId: 'client-1',
        status: 'active',
        openedAt: DateTime(2024, 1, 1),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        client: CaseClient(
          id: 'client-1',
          firstName: 'John',
          lastName: 'Doe',
          status: 'active',
        ),
      );
    });

    testWidgets('displays loading indicator while fetching data',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            caseDetailProvider('case-123').overrideWith(
              (ref) => Future.delayed(
                const Duration(seconds: 1),
                () => mockCaseDetail,
              ),
            ),
          ],
          child: MaterialApp(
            home: CaseDetailScreen(caseId: 'case-123'),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays case details when data is loaded',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            caseDetailProvider('case-123').overrideWith(
              (ref) => Future.value(mockCaseDetail),
            ),
            caseActivitiesProvider('case-123').overrideWith(
              (ref) => Future.value({
                'data': <Activity>[],
                'meta': {},
              }),
            ),
            caseServicesProvider('case-123').overrideWith(
              (ref) => Future.value({
                'data': <Service>[],
                'meta': {},
              }),
            ),
            caseDocumentsProvider('case-123').overrideWith(
              (ref) => Future.value({
                'data': <Document>[],
                'meta': {},
              }),
            ),
          ],
          child: MaterialApp(
            home: CaseDetailScreen(caseId: 'case-123'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Case Details'), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Activities'), findsOneWidget);
      expect(find.text('Documents'), findsOneWidget);
    });

    testWidgets('displays error message when data fetch fails',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            caseDetailProvider('case-123').overrideWith(
              (ref) => Future.error('Failed to load case'),
            ),
          ],
          child: MaterialApp(
            home: CaseDetailScreen(caseId: 'case-123'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Error loading case: Failed to load case'),
          findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('can switch between tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            caseDetailProvider('case-123').overrideWith(
              (ref) => Future.value(mockCaseDetail),
            ),
            caseActivitiesProvider('case-123').overrideWith(
              (ref) => Future.value({
                'data': <Activity>[],
                'meta': {},
              }),
            ),
            caseServicesProvider('case-123').overrideWith(
              (ref) => Future.value({
                'data': <Service>[],
                'meta': {},
              }),
            ),
            caseDocumentsProvider('case-123').overrideWith(
              (ref) => Future.value({
                'data': <Document>[],
                'meta': {},
              }),
            ),
          ],
          child: MaterialApp(
            home: CaseDetailScreen(caseId: 'case-123'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on Activities tab
      await tester.tap(find.text('Activities'));
      await tester.pumpAndSettle();

      // Tap on Documents tab
      await tester.tap(find.text('Documents'));
      await tester.pumpAndSettle();

      expect(find.text('No documents available'), findsOneWidget);
    });
  });
}

