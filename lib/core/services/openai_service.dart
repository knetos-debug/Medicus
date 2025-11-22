import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_provider_interface.dart';
import '../models/query_request.dart';
import '../models/query_response.dart';
import '../config/system_prompt.dart';
import '../config/api_endpoints.dart';

/// OpenAI (ChatGPT) AI service implementation
class OpenAIService implements AIProvider {
  final String apiKey;

  OpenAIService({required this.apiKey});

  @override
  String get providerName => 'ChatGPT (OpenAI)';

  @override
  String get providerId => 'openai';

  @override
  Future<QueryResponse> sendQuery(QueryRequest request) async {
    try {
      final userMessage = request.context != null
          ? '${request.query}\n\nYtterligare kontext: ${request.context}'
          : request.query;

      final response = await http
          .post(
            Uri.parse(APIEndpoints.openaiCompletions),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': APIEndpoints.openaiModel,
              'messages': [
                {
                  'role': 'system',
                  'content': SystemPrompt.clinicalAssistant,
                },
                {
                  'role': 'user',
                  'content': userMessage,
                }
              ],
              'max_tokens': 4096,
              'temperature': 0.7,
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;

        return QueryResponse(
          content: content,
          provider: providerName,
          timestamp: DateTime.now(),
          success: true,
          metadata: {
            'model': APIEndpoints.openaiModel,
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
