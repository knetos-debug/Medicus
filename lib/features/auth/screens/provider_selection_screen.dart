import 'package:flutter/material.dart';
import '../../../core/models/ai_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/utils/constants.dart';
import '../widgets/provider_card.dart';
import 'credential_setup_screen.dart';

class ProviderSelectionScreen extends StatelessWidget {
  const ProviderSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Välj AI Provider'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Constants.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Välkommen till Klinisk AI Assistent',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Constants.spacingMedium),

              Text(
                'Välj vilken AI-tjänst du vill använda. Du behöver en egen API-nyckel (BYOK - Bring Your Own Key).',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Constants.spacingXLarge),

              // Provider cards
              ProviderCard(
                provider: AIProviderType.claude,
                title: 'Claude (Anthropic)',
                description: 'Avancerad medicinsk förståelse och resonemang',
                icon: Icons.psychology,
                onTap: () => _navigateToSetup(context, AIProviderType.claude),
              ),
              const SizedBox(height: Constants.spacingMedium),

              ProviderCard(
                provider: AIProviderType.openai,
                title: 'ChatGPT (OpenAI)',
                description: 'Välkänd och pålitlig AI-assistent',
                icon: Icons.chat,
                onTap: () => _navigateToSetup(context, AIProviderType.openai),
              ),
              const SizedBox(height: Constants.spacingMedium),

              ProviderCard(
                provider: AIProviderType.gemini,
                title: 'Gemini (Google)',
                description: 'Googles senaste AI-modell',
                icon: Icons.stars,
                onTap: () => _navigateToSetup(context, AIProviderType.gemini),
              ),
              const SizedBox(height: Constants.spacingXLarge),

              // Info card
              Card(
                color: AppColors.primaryLight.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(Constants.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: AppColors.primary),
                          const SizedBox(width: Constants.spacingSmall),
                          Text(
                            'Om BYOK',
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Constants.spacingSmall),
                      Text(
                        '• Du betalar direkt till AI-leverantören\n'
                        '• Full kontroll över dina kostnader\n'
                        '• Inga mellanliggande servrar\n'
                        '• 100% privat och säkert',
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
    );
  }

  void _navigateToSetup(BuildContext context, AIProviderType provider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CredentialSetupScreen(provider: provider),
      ),
    );
  }
}
