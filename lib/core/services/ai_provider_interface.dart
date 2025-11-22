import '../models/query_request.dart';
import '../models/query_response.dart';

/// Abstract interface for AI providers
abstract class AIProvider {
  /// Send a query to the AI provider
  Future<QueryResponse> sendQuery(QueryRequest request);

  /// Test the connection to the provider
  Future<bool> testConnection();

  /// Get the provider name
  String get providerName;

  /// Get the provider identifier
  String get providerId;
}
