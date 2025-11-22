import 'package:flutter/material.dart';

/// Extension methods for String
extension StringExtensions on String {
  /// Check if string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Check if string is not null or empty
  bool get isNotNullOrEmpty {
    return isNotEmpty;
  }

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Remove all whitespace
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }
}

/// Extension methods for DateTime
extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is this week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return isAfter(startOfWeek);
  }

  /// Get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'år' : 'år'} sedan';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'månad' : 'månader'} sedan';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'dag' : 'dagar'} sedan';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'timme' : 'timmar'} sedan';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minut' : 'minuter'} sedan';
    } else {
      return 'Nyss';
    }
  }
}

/// Extension methods for BuildContext
extension BuildContextExtensions on BuildContext {
  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Check if mobile
  bool get isMobile => screenWidth < 600;

  /// Check if tablet
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;

  /// Check if desktop
  bool get isDesktop => screenWidth >= 900;

  /// Get theme
  ThemeData get theme => Theme.of(this);

  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Show snackbar
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  /// Hide keyboard
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
}
