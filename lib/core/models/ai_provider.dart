/// Supported AI providers
enum AIProviderType {
  claude,
  openai,
  gemini;

  /// Parse from storage key (web-safe alternative to values.byName)
  static AIProviderType? fromStorageKey(String key) {
    switch (key) {
      case 'claude':
        return AIProviderType.claude;
      case 'openai':
        return AIProviderType.openai;
      case 'gemini':
        return AIProviderType.gemini;
      default:
        return null;
    }
  }
}

extension AIProviderExtension on AIProviderType {
  /// Storage-safe string key (use instead of .name for web compatibility)
  String get storageKey {
    switch (this) {
      case AIProviderType.claude:
        return 'claude';
      case AIProviderType.openai:
        return 'openai';
      case AIProviderType.gemini:
        return 'gemini';
    }
  }

  String get displayName {
    switch (this) {
      case AIProviderType.claude:
        return 'Claude (Anthropic)';
      case AIProviderType.openai:
        return 'ChatGPT (OpenAI)';
      case AIProviderType.gemini:
        return 'Gemini (Google)';
    }
  }

  String get description {
    switch (this) {
      case AIProviderType.claude:
        return 'Avancerad medicinsk förståelse och resonemang';
      case AIProviderType.openai:
        return 'Välkänd och pålitlig AI-assistent';
      case AIProviderType.gemini:
        return 'Googles senaste AI-modell';
    }
  }

  String get apiKeyUrl {
    switch (this) {
      case AIProviderType.claude:
        return 'https://console.anthropic.com';
      case AIProviderType.openai:
        return 'https://platform.openai.com';
      case AIProviderType.gemini:
        return 'https://makersuite.google.com';
    }
  }

  String get instructions {
    switch (this) {
      case AIProviderType.claude:
        return 'Skaffa en API-nyckel på console.anthropic.com';
      case AIProviderType.openai:
        return 'Skaffa en API-nyckel på platform.openai.com';
      case AIProviderType.gemini:
        return 'Skaffa en API-nyckel på makersuite.google.com';
    }
  }
}
