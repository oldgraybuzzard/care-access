import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/clients_api.dart';
import '../../../core/models/client.dart';

/// Client detail provider - fetches full client details by ID
final clientDetailProvider =
    FutureProvider.autoDispose.family<ClientDetail, String>((ref, clientId) async {
  final api = ref.watch(clientsApiProvider);
  return await api.getClient(clientId);
});

/// Client cases provider - fetches all cases for a client
final clientCasesProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, clientId) async {
  final api = ref.watch(clientsApiProvider);
  return await api.getClientCases(clientId);
});

