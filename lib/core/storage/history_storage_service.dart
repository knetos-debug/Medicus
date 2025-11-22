import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/search_history_item.dart';

/// Service for managing search history
class HistoryStorageService {
  static const String _historyKey = 'search_history';
  static const int _maxHistoryItems = 100;

  /// Save a search history item
  Future<void> saveHistoryItem(SearchHistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getHistory();

    // Add new item at the beginning
    items.insert(0, item);

    // Keep only the most recent items
    if (items.length > _maxHistoryItems) {
      items.removeRange(_maxHistoryItems, items.length);
    }

    // Convert to JSON and save
    final jsonList = items.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_historyKey, jsonList);
  }

  /// Get all history items
  Future<List<SearchHistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_historyKey) ?? [];

    return jsonList.map((jsonString) {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return SearchHistoryItem.fromJson(json);
    }).toList();
  }

  /// Delete a specific history item
  Future<void> deleteHistoryItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getHistory();

    items.removeWhere((item) => item.id == id);

    final jsonList = items.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_historyKey, jsonList);
  }

  /// Clear all history
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  /// Toggle favorite status for an item
  Future<void> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getHistory();

    final index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      items[index] = items[index].copyWith(
        isFavorite: !items[index].isFavorite,
      );

      final jsonList = items.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList(_historyKey, jsonList);
    }
  }

  /// Get favorite items only
  Future<List<SearchHistoryItem>> getFavorites() async {
    final items = await getHistory();
    return items.where((item) => item.isFavorite).toList();
  }

  /// Search history items by query
  Future<List<SearchHistoryItem>> searchHistory(String query) async {
    final items = await getHistory();
    final lowercaseQuery = query.toLowerCase();

    return items.where((item) {
      return item.request.query.toLowerCase().contains(lowercaseQuery) ||
          item.response.content.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Get history items from a specific date range
  Future<List<SearchHistoryItem>> getHistoryByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final items = await getHistory();

    return items.where((item) {
      return item.timestamp.isAfter(start) && item.timestamp.isBefore(end);
    }).toList();
  }

  /// Get total number of history items
  Future<int> getHistoryCount() async {
    final items = await getHistory();
    return items.length;
  }
}
