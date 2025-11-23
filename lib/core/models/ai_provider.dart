/// Supported AI providers
enum AIProviderType {
  claude(
    storageKey: 'claude',
    displayName: 'Claude (Anthropic)',
    description: 'Avancerad medicinsk förståelse och resonemang',
    apiKeyUrl: 'https://console.anthropic.com',
    instructions: 'Skaffa en API-nyckel på console.anthropic.com',
  ),
  openai(
    storageKey: 'openai',
    displayName: 'ChatGPT (OpenAI)',
    description: 'Välkänd och pålitlig AI-assistent',
    apiKeyUrl: 'https://platform.openai.com',
    instructions: 'Skaffa en API-nyckel på platform.openai.com',
  ),
  gemini(
    storageKey: 'gemini',
    displayName: 'Gemini (Google)',
    description: 'Googles senaste AI-modell',
    apiKeyUrl: 'https://makersuite.google.com',
    instructions: 'Skaffa en API-nyckel på makersuite.google.com',
  );

  const AIProviderType({
    required this.storageKey,
    required this.displayName,
    required this.description,
    required this.apiKeyUrl,
    required this.instructions,
  });

  final String storageKey;
  final String displayName;
  final String description;
  final String apiKeyUrl;
  final String instructions;

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
