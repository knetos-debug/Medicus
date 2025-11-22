import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_provider_interface.dart';
import '../models/query_request.dart';
import '../models/query_response.dart';
import '../config/system_prompt.dart';
import '../config/api_endpoints.dart';

/// Anthropic (Claude) AI service implementation
class AnthropicService implements AIProvider {
  final String apiKey;

  AnthropicService({required this.apiKey});

  @override
  String get providerName => 'Claude (Anthropic)';

  @override
  String get providerId => 'claude';

  @override
  Future<QueryResponse> sendQuery(QueryRequest request) async {
    try {
      final prompt = SystemPrompt.buildPrompt(
        userQuery: request.query,
        additionalContext: request.context,
      );

      final response = await http
          .post(
            Uri.parse(APIEndpoints.anthropicMessages),
            headers: {
              'x-api-key': apiKey,
              'anthropic-version': APIEndpoints.anthropicVersion,
              'content-type': 'application/json',
            },
            body: jsonEncode({
              'model': APIEndpoints.anthropicModel,
              'max_tokens': 4096,
              'messages': [
                {
                  'role': 'user',
                  'content': prompt,
                }
              ],
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['content'][0]['text'] as String;

        return QueryResponse(
          content: content,
          provider: providerName,
          timestamp: DateTime.now(),
          success: true,
          metadata: {
            'model': APIEndpoints.anthropicModel,
            'usage': data['usage'],
          },
        );
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          'API Error ${response.statusCode}: ${errorData['error']?['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      return QueryResponse(
        content: '',
        provider: providerName,
        timestamp: DateTime.now(),
        success: false,
        error: e.toString(),
      );
    }
  }

  @override
  Future<bool> testConnection() async {
    try {
      final testRequest = QueryRequest(
        query: 'Säg bara "OK" om du fungerar.',
        timestamp: DateTime.now(),
      );
      final response = await sendQuery(testRequest);
      return response.success;
    } catch (e) {
      return false;
    }
  }
}
