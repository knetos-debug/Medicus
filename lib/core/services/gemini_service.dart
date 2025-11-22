import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_provider_interface.dart';
import '../models/query_request.dart';
import '../models/query_response.dart';
import '../config/system_prompt.dart';
import '../config/api_endpoints.dart';

/// Google Gemini AI service implementation
class GeminiService implements AIProvider {
  final String apiKey;

  GeminiService({required this.apiKey});

  @override
  String get providerName => 'Gemini (Google)';

  @override
  String get providerId => 'gemini';

  @override
  Future<QueryResponse> sendQuery(QueryRequest request) async {
    try {
      final prompt = SystemPrompt.buildPrompt(
        userQuery: request.query,
        additionalContext: request.context,
      );

      final response = await http
          .post(
            Uri.parse(APIEndpoints.geminiGenerateContent(apiKey)),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt}
                  ]
                }
              ],
              'generationConfig': {
                'maxOutputTokens': 4096,
                'temperature': 0.7,
              }
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content =
            data['candidates'][0]['content']['parts'][0]['text'] as String;

        return QueryResponse(
          content: content,
          provider: providerName,
          timestamp: DateTime.now(),
          success: true,
          metadata: {
            'model': APIEndpoints.geminiModel,
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
