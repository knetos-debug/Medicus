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
            Uri.parse(APIEndpoints.geminiGenerateContentUrl),
            headers: {
              'Content-Type': 'application/json',
              'x-goog-api-key': apiKey, // SECURITY: API key in header, not URL
            },
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt}
                  ]
                }
              ],
              'tools': [
                {
                  'google_search': {}  // Enable Google Search grounding!
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

        // Check if response has the expected structure
        if (data['candidates'] == null || data['candidates'].isEmpty) {
          throw Exception(
            'Gemini API returned empty response. '
            'This may be due to safety filters or content policy.'
          );
        }

        final content =
            data['candidates'][0]['content']['parts'][0]['text'] as String;

        // Extract grounding metadata (citations from Google Search)
        final groundingMetadata = data['candidates'][0]['groundingMetadata'];
        final Map<String, dynamic> metadata = {
          'model': APIEndpoints.geminiModel,
          'grounded': groundingMetadata != null,
        };

        // Parse grounding sources (web citations)
        if (groundingMetadata != null) {
          final webSearchQueries = groundingMetadata['webSearchQueries'] as List?;
          final groundingChunks = groundingMetadata['groundingChunks'] as List?;

          metadata['searchQueries'] = webSearchQueries ?? [];

          // Extract source URLs and titles
          if (groundingChunks != null && groundingChunks.isNotEmpty) {
            final sources = groundingChunks.map((chunk) {
              final web = chunk['web'];
              return {
                'uri': web?['uri'] ?? '',
                'title': web?['title'] ?? 'Källa',
              };
            }).toList();
            metadata['sources'] = sources;
          }
        }

        return QueryResponse(
          content: content,
          provider: providerName,
          timestamp: DateTime.now(),
          success: true,
          metadata: metadata,
        );
      } else {
        // Parse Gemini error format
        String errorMessage = 'Unknown error';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['error'] != null) {
            errorMessage = errorData['error']['message'] ??
                          errorData['error']['status'] ??
                          'Unknown error';

            // Add helpful context for common errors
            if (response.statusCode == 400) {
              if (errorMessage.contains('API_KEY_INVALID')) {
                errorMessage = 'API-nyckeln är ogiltig. Kontrollera att du har kopierat hela nyckeln.';
              } else {
                errorMessage += '\n\nKontrollera att API-nyckeln är korrekt.';
              }
            } else if (response.statusCode == 403) {
              errorMessage = 'API-nyckeln saknar behörighet eller Gemini API är inte aktiverat.\n\n'
                           'Aktivera Gemini API på: https://makersuite.google.com';
            } else if (response.statusCode == 404) {
              errorMessage = 'Gemini API endpoint hittades inte.\n\n'
                           'Detta betyder ofta att:\n'
                           '• Generative Language API inte är aktiverat för ditt projekt\n'
                           '• API-nyckeln är skapad för fel projekt\n'
                           '• Modellen "${APIEndpoints.geminiModel}" inte är tillgänglig\n\n'
                           'Aktivera API:et på: https://console.cloud.google.com/apis/library/generativelanguage.googleapis.com\n'
                           'Eller skapa ny API-nyckel på: https://aistudio.google.com/app/apikey';
            } else if (response.statusCode == 429) {
              errorMessage = 'Rate limit nådd. Försök igen om en stund.';
            }
          }
        } catch (e) {
          errorMessage = response.body.length > 200
            ? response.body.substring(0, 200) + '...'
            : response.body;
        }

        throw Exception('Gemini API Error (${response.statusCode}): $errorMessage');
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
