import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/query_request.dart';
import '../../../core/models/query_response.dart';
import '../../../core/models/search_history_item.dart';
import '../../../core/storage/history_storage_service.dart';
import '../../../core/storage/preferences_service.dart';
import '../../auth/providers/auth_provider.dart';

// History storage service provider
final historyStorageProvider = Provider((ref) => HistoryStorageService());

// Preferences service provider
final preferencesServiceProvider = Provider((ref) => PreferencesService());

// Current query text provider
final queryTextProvider = StateProvider<String>((ref) => '');

// Loading state provider
final isLoadingProvider = StateProvider<bool>((ref) => false);

// Current response provider
final currentResponseProvider = StateProvider<QueryResponse?>((ref) => null);

// Query actions provider
final queryActionsProvider = Provider((ref) => QueryActions(ref));

class QueryActions {
  final Ref ref;

  QueryActions(this.ref);

  /// Send a query to the AI
  Future<QueryResponse?> sendQuery(String query) async {
    try {
      // Set loading state
      ref.read(isLoadingProvider.notifier).state = true;

      // Get AI service
      final aiService = ref.read(aiServiceProvider);
      if (aiService == null) {
        throw Exception('Ingen AI-tjänst tillgänglig. Vänligen logga in igen.');
      }

      // Create request
      final request = QueryRequest(
        query: query,
        timestamp: DateTime.now(),
      );

      // Send query
      final response = await aiService.sendQuery(request);

      if (!response.success) {
        throw Exception(response.error ?? 'Okänt fel vid fråga till AI');
      }

      // Save to history if enabled
      final prefs = ref.read(preferencesServiceProvider);
      final historyEnabled = await prefs.isHistoryEnabled();

      if (historyEnabled) {
        final historyItem = SearchHistoryItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          request: request,
          response: response,
          timestamp: DateTime.now(),
        );

        final historyStorage = ref.read(historyStorageProvider);
        await historyStorage.saveHistoryItem(historyItem);
      }

      // Update current response
      ref.read(currentResponseProvider.notifier).state = response;

      return response;
    } catch (e) {
      return QueryResponse(
        content: '',
        provider: '',
        timestamp: DateTime.now(),
        success: false,
        error: e.toString(),
      );
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  /// Clear current query and response
  void clearQuery() {
    ref.read(queryTextProvider.notifier).state = '';
    ref.read(currentResponseProvider.notifier).state = null;
  }
}

// Search history provider
final searchHistoryProvider = FutureProvider<List<SearchHistoryItem>>((ref) async {
  final historyStorage = ref.read(historyStorageProvider);
  return await historyStorage.getHistory();
});

// Favorites provider
final favoritesProvider = FutureProvider<List<SearchHistoryItem>>((ref) async {
  final historyStorage = ref.read(historyStorageProvider);
  return await historyStorage.getFavorites();
});
