/// API endpoints for different providers
class APIEndpoints {
  // Anthropic (Claude)
  static const String anthropicMessages = 'https://api.anthropic.com/v1/messages';
  static const String anthropicVersion = '2023-06-01';
  static const String anthropicModel = 'claude-sonnet-4-20250514';

  // OpenAI (ChatGPT)
  static const String openaiCompletions = 'https://api.openai.com/v1/chat/completions';
  static const String openaiModel = 'gpt-4-turbo-preview';

  // Google (Gemini)
  // Note: Using Gemini 2.5 Flash - stable model as of 2025
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String geminiModel = 'gemini-2.5-flash';

  // SECURITY: API key should be passed in header, not URL
  static String get geminiGenerateContentUrl {
    return '$geminiBaseUrl/models/$geminiModel:generateContent';
  }
}
