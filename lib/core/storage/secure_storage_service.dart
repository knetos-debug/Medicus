import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/ai_provider.dart';

/// Service for securely storing sensitive data like API keys
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'klinisk_ai_secure',
      publicKey: 'klinisk_ai_public_key',
    ),
  );

  // Storage keys
  static const _providerKey = 'selected_provider';
  static const _apiKeyPrefix = 'api_key_';

  /// Save the selected AI provider
  Future<void> saveSelectedProvider(AIProviderType provider) async {
    await _storage.write(
      key: _providerKey,
      value: provider.storageKey,
    );
  }

  /// Get the selected AI provider
  Future<AIProviderType?> getSelectedProvider() async {
    final providerName = await _storage.read(key: _providerKey);
    if (providerName == null) return null;

    return AIProviderType.fromStorageKey(providerName);
  }

  /// Save an API key for a specific provider
  Future<void> saveApiKey(AIProviderType provider, String apiKey) async {
    await _storage.write(
      key: '$_apiKeyPrefix${provider.storageKey}',
      value: apiKey,
    );
  }

  /// Get the API key for a specific provider
  Future<String?> getApiKey(AIProviderType provider) async {
    return await _storage.read(key: '$_apiKeyPrefix${provider.storageKey}');
  }

  /// Delete the API key for a specific provider
  Future<void> deleteApiKey(AIProviderType provider) async {
    await _storage.delete(key: '$_apiKeyPrefix${provider.storageKey}');
  }

  /// Check if an API key exists for a provider
  Future<bool> hasApiKey(AIProviderType provider) async {
    final apiKey = await getApiKey(provider);
    return apiKey != null && apiKey.isNotEmpty;
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Get all storage keys (for debugging)
  Future<Map<String, String>> getAllKeys() async {
    return await _storage.readAll();
  }
}
