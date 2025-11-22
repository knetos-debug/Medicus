import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/ai_provider.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/services/ai_service_factory.dart';
import '../../../core/services/ai_provider_interface.dart';

// Storage service provider
final storageServiceProvider = Provider((ref) => SecureStorageService());

// Selected provider state
final selectedProviderProvider = StateProvider<AIProviderType?>((ref) => null);

// API key state
final apiKeyProvider = StateProvider<String?>((ref) => null);

// AI service provider (combines provider type and API key)
final aiServiceProvider = Provider<AIProvider?>((ref) {
  final provider = ref.watch(selectedProviderProvider);
  final apiKey = ref.watch(apiKeyProvider);

  if (provider == null || apiKey == null || apiKey.isEmpty) {
    return null;
  }

  return AIServiceFactory.create(
    provider: provider,
    apiKey: apiKey,
  );
});

// Auth state provider (checks if user is authenticated)
final authStateProvider = FutureProvider<bool>((ref) async {
  final storage = ref.read(storageServiceProvider);

  // Get selected provider
  final provider = await storage.getSelectedProvider();
  if (provider == null) return false;

  // Get API key for that provider
  final apiKey = await storage.getApiKey(provider);
  if (apiKey == null || apiKey.isEmpty) return false;

  // Update state
  ref.read(selectedProviderProvider.notifier).state = provider;
  ref.read(apiKeyProvider.notifier).state = apiKey;

  return true;
});

// Auth actions provider
final authActionsProvider = Provider((ref) => AuthActions(ref));

class AuthActions {
  final Ref ref;

  AuthActions(this.ref);

  /// Save credentials and update state
  Future<void> saveCredentials({
    required AIProviderType provider,
    required String apiKey,
  }) async {
    final storage = ref.read(storageServiceProvider);

    await storage.saveSelectedProvider(provider);
    await storage.saveApiKey(provider, apiKey);

    ref.read(selectedProviderProvider.notifier).state = provider;
    ref.read(apiKeyProvider.notifier).state = apiKey;
  }

  /// Test connection with provided credentials
  Future<bool> testConnection({
    required AIProviderType provider,
    required String apiKey,
  }) async {
    try {
      final service = AIServiceFactory.create(
        provider: provider,
        apiKey: apiKey,
      );

      return await service.testConnection();
    } catch (e) {
      return false;
    }
  }

  /// Logout and clear credentials
  Future<void> logout() async {
    final storage = ref.read(storageServiceProvider);
    await storage.clearAll();

    ref.read(selectedProviderProvider.notifier).state = null;
    ref.read(apiKeyProvider.notifier).state = null;
  }

  /// Switch to a different provider
  Future<void> switchProvider(AIProviderType provider) async {
    final storage = ref.read(storageServiceProvider);
    final apiKey = await storage.getApiKey(provider);

    if (apiKey != null) {
      await storage.saveSelectedProvider(provider);
      ref.read(selectedProviderProvider.notifier).state = provider;
      ref.read(apiKeyProvider.notifier).state = apiKey;
    }
  }
}
