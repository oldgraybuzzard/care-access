import 'package:flutter_test/flutter_test.dart';
import 'package:fcf_app/core/models/case.dart';

void main() {
  group('CaseDetail', () {
    test('fromJson creates valid CaseDetail object', () {
      final json = {
        'id': 'case-123',
        'vendorSourceId': 'vendor-1',
        'vendorCaseId': 'vc-001',
        'clientId': 'client-1',
        'status': 'active',
        'openedAt': '2024-01-01T00:00:00.000Z',
        'closedAt': null,
        'assignedWorkerId': null,
        'programId': null,
        'metaJson': {},
        'createdAt': '2024-01-01T00:00:00.000Z',
        'updatedAt': '2024-01-01T00:00:00.000Z',
      };

      final caseDetail = CaseDetail.fromJson(json);

      expect(caseDetail.id, 'case-123');
      expect(caseDetail.vendorCaseId, 'vc-001');
      expect(caseDetail.status, 'active');
      expect(caseDetail.isOpen, true);
      expect(caseDetail.isClosed, false);
    });

    test('isOpen returns true when closedAt is null', () {
      final caseDetail = CaseDetail(
        id: '1',
        vendorSourceId: 'v1',
        vendorCaseId: 'vc1',
        clientId: 'c1',
        status: 'active',
        openedAt: DateTime(2024, 1, 1),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(caseDetail.isOpen, true);
      expect(caseDetail.isClosed, false);
    });

    test('isClosed returns true when closedAt is set', () {
      final caseDetail = CaseDetail(
        id: '1',
        vendorSourceId: 'v1',
        vendorCaseId: 'vc1',
        clientId: 'c1',
        status: 'closed',
        openedAt: DateTime(2024, 1, 1),
        closedAt: DateTime(2024, 2, 1),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(caseDetail.isOpen, false);
      expect(caseDetail.isClosed, true);
    });

    test('daysOpen calculates correctly for open case', () {
      final openedAt = DateTime.now().subtract(const Duration(days: 10));
      final caseDetail = CaseDetail(
        id: '1',
        vendorSourceId: 'v1',
        vendorCaseId: 'vc1',
        clientId: 'c1',
        status: 'active',
        openedAt: openedAt,
        createdAt: openedAt,
        updatedAt: openedAt,
      );

      expect(caseDetail.daysOpen, 10);
    });

    test('daysOpen calculates correctly for closed case', () {
      final openedAt = DateTime(2024, 1, 1);
      final closedAt = DateTime(2024, 1, 11);
      final caseDetail = CaseDetail(
        id: '1',
        vendorSourceId: 'v1',
        vendorCaseId: 'vc1',
        clientId: 'c1',
        status: 'closed',
        openedAt: openedAt,
        closedAt: closedAt,
        createdAt: openedAt,
        updatedAt: closedAt,
      );

      expect(caseDetail.daysOpen, 10);
    });
  });

  group('CaseClient', () {
    test('fullName combines firstName and lastName', () {
      final client = CaseClient(
        id: '1',
        firstName: 'John',
        lastName: 'Doe',
        status: 'active',
      );

      expect(client.fullName, 'John Doe');
    });

    test('fromJson creates valid CaseClient object', () {
      final json = {
        'id': 'client-1',
        'firstName': 'Jane',
        'lastName': 'Smith',
        'dob': '1990-01-15T00:00:00.000Z',
        'status': 'active',
      };

      final client = CaseClient.fromJson(json);

      expect(client.id, 'client-1');
      expect(client.firstName, 'Jane');
      expect(client.lastName, 'Smith');
      expect(client.fullName, 'Jane Smith');
      expect(client.status, 'active');
      expect(client.dob, isNotNull);
    });
  });

  group('Service', () {
    test('isActive returns true for active service', () {
      final service = Service(
        id: '1',
        vendorSourceId: 'v1',
        vendorServiceId: 'vs1',
        caseId: 'c1',
        serviceType: 'Counseling',
        startAt: DateTime.now().subtract(const Duration(days: 5)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(service.isActive, true);
    });

    test('isActive returns false for ended service', () {
      final service = Service(
        id: '1',
        vendorSourceId: 'v1',
        vendorServiceId: 'vs1',
        caseId: 'c1',
        serviceType: 'Counseling',
        startAt: DateTime.now().subtract(const Duration(days: 10)),
        endAt: DateTime.now().subtract(const Duration(days: 1)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(service.isActive, false);
    });
  });
}

