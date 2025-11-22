/// Validators for form inputs
class Validators {
  /// Validate API key format
  static String? validateApiKey(String? value, {String? provider}) {
    if (value == null || value.isEmpty) {
      return 'Vänligen ange en API-nyckel';
    }

    if (value.length < 10) {
      return 'API-nyckeln verkar vara för kort';
    }

    // Provider-specific validation
    if (provider != null) {
      switch (provider.toLowerCase()) {
        case 'claude':
        case 'anthropic':
          if (!value.startsWith('sk-ant-')) {
            return 'Anthropic API-nycklar börjar med "sk-ant-"';
          }
          break;
        case 'openai':
        case 'chatgpt':
          if (!value.startsWith('sk-')) {
            return 'OpenAI API-nycklar börjar med "sk-"';
          }
          break;
        case 'gemini':
        case 'google':
          // Gemini keys are typically alphanumeric
          if (value.length < 20) {
            return 'Google API-nyckeln verkar vara ogiltig';
          }
          break;
      }
    }

    return null;
  }

  /// Validate query text
  static String? validateQuery(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vänligen ange en fråga';
    }

    if (value.length < 3) {
      return 'Frågan måste vara minst 3 tecken';
    }

    if (value.length > 5000) {
      return 'Frågan är för lång (max 5000 tecken)';
    }

    return null;
  }

  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vänligen ange en e-postadress';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Vänligen ange en giltig e-postadress';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return 'Vänligen fyll i ${fieldName ?? 'detta fält'}';
    }
    return null;
  }
}
