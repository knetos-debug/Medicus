import 'package:intl/intl.dart';

/// Utility class for formatting data
class Formatters {
  /// Format a DateTime to a readable string
  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Nyss';
        }
        return '${difference.inMinutes} min sedan';
      }
      return '${difference.inHours} tim sedan';
    } else if (difference.inDays == 1) {
      return 'Igår ${DateFormat('HH:mm').format(dateTime)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dagar sedan';
    } else {
      return DateFormat('d MMM yyyy', 'sv_SE').format(dateTime);
    }
  }

  /// Format a date only
  static String formatDate(DateTime dateTime) {
    return DateFormat('d MMMM yyyy', 'sv_SE').format(dateTime);
  }

  /// Format time only
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Format a duration
  static String formatDuration(Duration duration) {
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds}s';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
  }

  /// Truncate text with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
