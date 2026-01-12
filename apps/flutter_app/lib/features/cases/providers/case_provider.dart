import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/cases_api.dart';
import '../../../core/models/case.dart';

/// Case detail provider - fetches full case details by ID
final caseDetailProvider =
    FutureProvider.autoDispose.family<CaseDetail, String>((ref, caseId) async {
  final api = ref.watch(casesApiProvider);
  return await api.getCase(caseId);
});

/// Case activities provider - fetches all activities for a case
final caseActivitiesProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, caseId) async {
  final api = ref.watch(casesApiProvider);
  return await api.getCaseActivities(caseId);
});

/// Case services provider - fetches all services for a case
final caseServicesProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, caseId) async {
  final api = ref.watch(casesApiProvider);
  return await api.getCaseServices(caseId);
});

/// Case documents provider - fetches all documents for a case
final caseDocumentsProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, caseId) async {
  final api = ref.watch(casesApiProvider);
  return await api.getCaseDocuments(caseId);
});

/// Case notes provider - fetches all notes for a case
final caseNotesProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, caseId) async {
  final api = ref.watch(casesApiProvider);
  return await api.getCaseNotes(caseId);
});
