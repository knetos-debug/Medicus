import 'ai_provider_interface.dart';
import 'anthropic_service.dart';
import 'openai_service.dart';
import 'gemini_service.dart';
import '../models/ai_provider.dart';

/// Factory for creating AI service instances
class AIServiceFactory {
  /// Create an AI provider service based on the provider type
  static AIProvider create({
    required AIProviderType provider,
    required String apiKey,
  }) {
    switch (provider) {
      case AIProviderType.claude:
        return AnthropicService(apiKey: apiKey);
      case AIProviderType.openai:
        return OpenAIService(apiKey: apiKey);
      case AIProviderType.gemini:
        return GeminiService(apiKey: apiKey);
    }
  }
}
