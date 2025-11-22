/// Application configuration
class AppConfig {
  // App Info
  static const String appName = 'Klinisk AI Assistent';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Kliniskt beslutsstöd för svenska läkare';

  // Storage Keys
  static const String storageKeyPrefix = 'klinisk_ai_';
  static const String selectedProviderKey = '${storageKeyPrefix}selected_provider';
  static const String historyKey = '${storageKeyPrefix}history';
  static const String favoritesKey = '${storageKeyPrefix}favorites';
  static const String settingsKey = '${storageKeyPrefix}settings';

  // API Configuration
  static const int apiTimeoutSeconds = 60;
  static const int maxRetries = 3;
  static const int maxTokens = 4096;

  // UI Configuration
  static const int historyItemsPerPage = 20;
  static const int maxHistoryItems = 100;
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Privacy & Legal
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String termsOfServiceUrl = 'https://example.com/terms';
  static const String supportEmail = 'support@example.com';

  // Medical Disclaimer
  static const String medicalDisclaimer = '''
⚠️ VIKTIG INFORMATION

Detta är ett beslutsstödsverktyg för legitimerade läkare och är INTE en ersättning för professionell medicinsk bedömning.

• Verifiera alltid AI-genererade rekommendationer
• Använd ditt kliniska omdöme
• Följ etablerade riktlinjer och vårdprogram
• Detta verktyg är inte avsett för akuta situationer
• Konsultera alltid med kollegor vid osäkerhet

Läkaren har alltid det yttersta kliniska ansvaret.
''';
}
