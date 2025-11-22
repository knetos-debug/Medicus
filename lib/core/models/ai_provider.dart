/// Supported AI providers
enum AIProviderType {
  claude,
  openai,
  gemini,
}

extension AIProviderExtension on AIProviderType {
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
