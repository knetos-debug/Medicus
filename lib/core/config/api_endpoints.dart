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
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String geminiModel = 'gemini-pro';

  static String geminiGenerateContent(String apiKey) {
    return '$geminiBaseUrl/models/$geminiModel:generateContent?key=$apiKey';
  }
}
