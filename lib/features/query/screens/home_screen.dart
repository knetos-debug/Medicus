import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/system_prompt.dart';
import '../../../core/models/ai_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/validators.dart';
import '../../auth/providers/auth_provider.dart';
import '../../results/screens/response_display_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../history/screens/search_history_screen.dart';
import '../providers/query_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _queryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedProvider = ref.watch(selectedProviderProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Klinisk AI Assistent'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Historik',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchHistoryScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Inställningar',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Provider indicator
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Constants.spacingSmall),
              color: AppColors.primaryLight.withValues(alpha: 0.3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getProviderIcon(selectedProvider),
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: Constants.spacingSmall),
                  Text(
                    'Använder: ${selectedProvider?.displayName ?? 'Ingen provider'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),

            // Medical disclaimer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Constants.spacingMedium),
              margin: const EdgeInsets.all(Constants.spacingMedium),
              decoration: BoxDecoration(
                color: AppColors.warningLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(Constants.radiusMedium),
                border: Border.all(color: AppColors.warning),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: Constants.spacingSmall),
                  Expanded(
                    child: Text(
                      'Beslutsstöd - ej ersättning för klinisk bedömning',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            // Quick templates
            SizedBox(
              height: 100,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.spacingMedium,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: SystemPrompt.quickTemplates.length,
                itemBuilder: (context, index) {
                  final template = SystemPrompt.quickTemplates.entries.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: Constants.spacingSmall,
                    ),
                    child: _QuickTemplateCard(
                      title: template.key,
                      onTap: () {
                        _queryController.text = template.value;
                        _queryController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _queryController.text.length),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // Query input
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Constants.spacingMedium),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _queryController,
                        decoration: const InputDecoration(
                          labelText: 'Ställ en klinisk fråga',
                          hintText: 'T.ex. "45-årig man med akut bröstsmärta..."',
                          prefixIcon: Icon(Icons.medical_services),
                        ),
                        maxLines: 10,
                        validator: Validators.validateQuery,
                      ),
                      const SizedBox(height: Constants.spacingMedium),

                      ElevatedButton.icon(
                        onPressed: isLoading ? null : _submitQuery,
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.send),
                        label: Text(isLoading ? 'Skickar...' : 'Skicka fråga'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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

  Future<void> _submitQuery() async {
    if (!_formKey.currentState!.validate()) return;

    final queryActions = ref.read(queryActionsProvider);
    final response = await queryActions.sendQuery(_queryController.text);

    if (mounted && response != null) {
      if (response.success) {
        // Navigate to response screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResponseDisplayScreen(
              query: _queryController.text,
              response: response,
            ),
          ),
        );

        // Clear query
        _queryController.clear();
      } else {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fel: ${response.error}'),
            backgroundColor: AppColors.danger,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}

class _QuickTemplateCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _QuickTemplateCard({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Constants.radiusMedium),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(Constants.spacingMedium),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Constants.radiusMedium),
          border: Border.all(color: AppColors.primary),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForTemplate(title),
              color: AppColors.primary,
              size: 32,
            ),
            const SizedBox(height: Constants.spacingSmall),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTemplate(String title) {
    if (title.contains('Differential')) return Icons.list_alt;
    if (title.contains('Läkemedel')) return Icons.medication;
    if (title.contains('Dosering')) return Icons.local_pharmacy;
    if (title.contains('Akut')) return Icons.emergency;
    if (title.contains('Utredning')) return Icons.science;
    if (title.contains('Risk')) return Icons.assessment;
    return Icons.help_outline;
  }
}
