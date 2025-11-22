import 'package:shared_preferences/shared_preferences.dart';

/// Service for storing user preferences
class PreferencesService {
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language';
  static const String _disclaimerShownKey = 'disclaimer_shown';
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _historyEnabledKey = 'history_enabled';
  static const String _voiceInputEnabledKey = 'voice_input_enabled';

  /// Save theme preference
  Future<void> setThemeMode(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme);
  }

  /// Get theme preference
  Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey);
  }

  /// Save language preference
  Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  /// Get language preference
  Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }

  /// Mark disclaimer as shown
  Future<void> setDisclaimerShown(bool shown) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_disclaimerShownKey, shown);
  }

  /// Check if disclaimer has been shown
  Future<bool> isDisclaimerShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_disclaimerShownKey) ?? false;
  }

  /// Mark onboarding as complete
  Future<void> setOnboardingComplete(bool complete) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, complete);
  }

  /// Check if onboarding is complete
  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  /// Enable/disable history
  Future<void> setHistoryEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_historyEnabledKey, enabled);
  }

  /// Check if history is enabled
  Future<bool> isHistoryEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_historyEnabledKey) ?? true;
  }

  /// Enable/disable voice input
  Future<void> setVoiceInputEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_voiceInputEnabledKey, enabled);
  }

  /// Check if voice input is enabled
  Future<bool> isVoiceInputEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_voiceInputEnabledKey) ?? true;
  }

  /// Clear all preferences
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
