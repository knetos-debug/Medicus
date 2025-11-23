import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/ai_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/validators.dart';
import '../../query/screens/home_screen.dart';
import '../providers/auth_provider.dart';

class CredentialSetupScreen extends ConsumerStatefulWidget {
  final AIProviderType provider;

  const CredentialSetupScreen({
    super.key,
    required this.provider,
  });

  @override
  ConsumerState<CredentialSetupScreen> createState() =>
      _CredentialSetupScreenState();
}

class _CredentialSetupScreenState
    extends ConsumerState<CredentialSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiKeyController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.provider.displayName),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Constants.spacingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon
                Icon(
                  _getProviderIcon(),
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: Constants.spacingLarge),

                // Title
                Text(
                  'Konfigurera ${widget.provider.displayName}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Constants.spacingMedium),

                // Instructions
                Text(
                  widget.provider.instructions,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Constants.spacingXLarge),

                // API Key input
                TextFormField(
                  controller: _apiKeyController,
                  decoration: InputDecoration(
                    labelText: 'API-nyckel',
                    hintText: 'Klistra in din API-nyckel här',
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText,
                  validator: (value) => Validators.validateApiKey(
                    value,
                    provider: widget.provider.storageKey,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: Constants.spacingLarge),

                // Test and Save button
                ElevatedButton(
                  onPressed: _isLoading ? null : _testAndSaveCredentials,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Testa och Spara'),
                ),
                const SizedBox(height: Constants.spacingMedium),

                // Get API key button
                TextButton.icon(
                  onPressed: () {
                    // Open URL in browser
                    // In a real app, use url_launcher package
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Skaffa API-nyckel'),
                ),
                const SizedBox(height: Constants.spacingXLarge),

                // Security info card
                Card(
                  color: AppColors.primaryLight.withValues(alpha: 0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(Constants.spacingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.security, color: AppColors.primary),
                            const SizedBox(width: Constants.spacingSmall),
                            Text(
                              'Säkerhet & Integritet',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Constants.spacingSmall),
                        Text(
                          '• Din API-nyckel lagras krypterat lokalt på din enhet\n'
                          '• Ingen data skickas till våra servrar\n'
                          '• Konversationer skickas direkt till ${widget.provider.displayName}\n'
                          '• Du kan radera din nyckel när som helst\n'
                          '• GDPR-kompatibel - ingen datainsamling',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getProviderIcon() {
    switch (widget.provider) {
      case AIProviderType.claude:
        return Icons.psychology;
      case AIProviderType.openai:
        return Icons.chat;
      case AIProviderType.gemini:
        return Icons.stars;
    }
  }

  Future<void> _testAndSaveCredentials() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authActions = ref.read(authActionsProvider);

      // Test connection
      final result = await authActions.testConnection(
        provider: widget.provider,
        apiKey: _apiKeyController.text.trim(),
      );

      if (result['success'] != true) {
        final errorMsg = result['error'] ?? 'Unknown error';
        throw Exception(
          'Kunde inte ansluta till ${widget.provider.displayName}.\n\n'
          'Fel: $errorMsg\n\n'
          'Kontrollera:\n'
          '• API-nyckeln är korrekt\n'
          '• Betalningsmetod är tillagd\n'
          '• API-nyckeln har behörigheter',
        );
      }

      // Save credentials
      await authActions.saveCredentials(
        provider: widget.provider,
        apiKey: _apiKeyController.text.trim(),
      );

      if (mounted) {
        // Navigate to home screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fel: ${e.toString()}'),
            backgroundColor: AppColors.danger,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
