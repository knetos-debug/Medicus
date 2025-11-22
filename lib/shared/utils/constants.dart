/// Application constants
class Constants {
  // App info
  static const String appName = 'Klinisk AI Assistent';
  static const String appVersion = '1.0.0';

  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 60);
  static const Duration debounceDelay = Duration(milliseconds: 500);

  // Limits
  static const int maxHistoryItems = 100;
  static const int maxQueryLength = 5000;
  static const int maxResponseLength = 10000;

  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
}
