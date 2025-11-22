import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/formatters.dart';
import '../../query/providers/query_provider.dart';
import '../../results/screens/response_display_screen.dart';

class SearchHistoryScreen extends ConsumerWidget {
  const SearchHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(searchHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historik'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Rensa historik',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Rensa historik'),
                  content: const Text(
                    'Är du säker på att du vill radera all historik?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Avbryt'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Radera'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                final historyStorage = ref.read(historyStorageProvider);
                await historyStorage.clearHistory();
                ref.invalidate(searchHistoryProvider);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Historiken har raderats'),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: historyAsync.when(
        data: (history) {
          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: Constants.spacingMedium),
                  Text(
                    'Ingen historik än',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: Constants.spacingSmall),
                  Text(
                    'Dina tidigare frågor kommer att visas här',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(Constants.spacingMedium),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return Card(
                margin: const EdgeInsets.only(bottom: Constants.spacingMedium),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResponseDisplayScreen(
                          query: item.request.query,
                          response: item.response,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(Constants.radiusMedium),
                  child: Padding(
                    padding: const EdgeInsets.all(Constants.spacingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _getProviderIcon(item.response.provider),
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: Constants.spacingSmall),
                                Text(
                                  item.response.provider,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                            Text(
                              Formatters.formatDateTime(item.timestamp),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: Constants.spacingSmall),
                        Text(
                          Formatters.truncate(item.request.query, 150),
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.isFavorite) ...[
                          const SizedBox(height: Constants.spacingSmall),
                          const Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: AppColors.warning,
                              ),
                              SizedBox(width: Constants.spacingXSmall),
                              Text(
                                'Favorit',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Fel: ${error.toString()}'),
        ),
      ),
    );
  }

  IconData _getProviderIcon(String provider) {
    if (provider.toLowerCase().contains('claude')) return Icons.psychology;
    if (provider.toLowerCase().contains('gpt') ||
        provider.toLowerCase().contains('openai')) return Icons.chat;
    if (provider.toLowerCase().contains('gemini')) return Icons.stars;
    return Icons.help_outline;
  }
}
