import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/app_config.dart';
import '../../../core/models/ai_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/utils/constants.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/provider_selection_screen.dart';
import '../../query/providers/query_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProvider = ref.watch(selectedProviderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inställningar'),
      ),
      body: ListView(
        children: [
          // Provider section
          _SectionHeader(title: 'AI Provider'),
          ListTile(
            leading: Icon(
              _getProviderIcon(selectedProvider),
              color: AppColors.primary,
            ),
            title: Text(selectedProvider?.displayName ?? 'Ingen provider'),
            subtitle: const Text('Aktuell AI-tjänst'),
            trailing: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProviderSelectionScreen(),
                  ),
                );
              },
              child: const Text('Byt'),
            ),
          ),
          const Divider(),

          // History settings
          _SectionHeader(title: 'Historik'),
          _HistorySettingsTile(),
          const Divider(),

          // Privacy section
          _SectionHeader(title: 'Integritet'),
          ListTile(
            leading: const Icon(Icons.security, color: AppColors.primary),
            title: const Text('Dataskydd'),
            subtitle: const Text('GDPR-kompatibel, ingen datainsamling'),
            onTap: () {
              _showPrivacyInfo(context);
            },
          ),
          const Divider(),

          // About section
          _SectionHeader(title: 'Om appen'),
          ListTile(
            leading: const Icon(Icons.info, color: AppColors.primary),
            title: const Text('Version'),
            subtitle: Text(AppConfig.appVersion),
          ),
          ListTile(
            leading: const Icon(Icons.description, color: AppColors.primary),
            title: const Text('Medicinsk ansvarsfriskrivning'),
            onTap: () {
              _showDisclaimer(context);
            },
          ),
          const Divider(),

          // Logout section
          Padding(
            padding: const EdgeInsets.all(Constants.spacingMedium),
            child: OutlinedButton.icon(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logga ut'),
                    content: const Text(
                      'Är du säker på att du vill logga ut? '
                      'Din API-nyckel kommer att raderas från enheten.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Avbryt'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Logga ut'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true && context.mounted) {
                  final authActions = ref.read(authActionsProvider);
                  await authActions.logout();

                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProviderSelectionScreen(),
                      ),
                      (route) => false,
                    );
                  }
                }
              },
              icon: const Icon(Icons.logout, color: AppColors.danger),
              label: const Text(
                'Logga ut',
                style: TextStyle(color: AppColors.danger),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.danger),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getProviderIcon(provider) {
    if (provider == null) return Icons.help_outline;
    switch (provider.name) {
      case 'claude':
        return Icons.psychology;
      case 'openai':
        return Icons.chat;
      case 'gemini':
        return Icons.stars;
      default:
        return Icons.help_outline;
    }
  }

  void _showPrivacyInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dataskydd & Integritet'),
        content: const SingleChildScrollView(
          child: Text(
            '• Din API-nyckel lagras krypterat lokalt\n'
            '• Ingen data skickas till våra servrar\n'
            '• All kommunikation sker direkt med din AI-leverantör\n'
            '• Ingen användardata samlas in\n'
            '• GDPR-kompatibel\n'
            '• Du kan radera all data när som helst\n\n'
            'För mer information, se vår integritetspolicy.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stäng'),
          ),
        ],
      ),
    );
  }

  void _showDisclaimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Medicinsk ansvarsfriskrivning'),
        content: SingleChildScrollView(
          child: Text(AppConfig.medicalDisclaimer),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Jag förstår'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Constants.spacingMedium,
        Constants.spacingLarge,
        Constants.spacingMedium,
        Constants.spacingSmall,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _HistorySettingsTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: ref.read(preferencesServiceProvider).isHistoryEnabled(),
      builder: (context, snapshot) {
        final isEnabled = snapshot.data ?? true;

        return SwitchListTile(
          secondary: const Icon(Icons.history, color: AppColors.primary),
          title: const Text('Spara historik'),
          subtitle: const Text('Spara tidigare frågor och svar'),
          value: isEnabled,
          onChanged: (value) async {
            await ref.read(preferencesServiceProvider).setHistoryEnabled(value);
            ref.invalidate(searchHistoryProvider);
          },
        );
      },
    );
  }
}
