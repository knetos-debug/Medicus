import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/query_response.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/formatters.dart';

class ResponseDisplayScreen extends StatelessWidget {
  final String query;
  final QueryResponse response;

  const ResponseDisplayScreen({
    super.key,
    required this.query,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI-svar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Kopiera svar',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: response.content));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Svaret kopierat till urklipp'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Dela',
            onPressed: () {
              // Implement share functionality
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Constants.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Query card
              Card(
                color: AppColors.primaryLight.withValues(alpha: 0.2),
                child: Padding(
                  padding: const EdgeInsets.all(Constants.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.question_answer,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: Constants.spacingSmall),
                          Text(
                            'Din fråga',
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
                        query,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Constants.spacingMedium),

              // Response metadata
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getProviderIcon(response.provider),
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: Constants.spacingSmall),
                      Text(
                        response.provider,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      // Show grounded badge if response used web search
                      if (response.metadata?['grounded'] == true) ...[
                        const SizedBox(width: Constants.spacingSmall),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.public,
                                size: 10,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'Real-time',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    Formatters.formatDateTime(response.timestamp),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Divider(height: Constants.spacingLarge),

              // Response content
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(Constants.spacingMedium),
                  child: MarkdownBody(
                    data: response.content,
                    onTapLink: (text, href, title) async {
                      if (href != null) {
                        await _launchUrl(href, context);
                      }
                    },
                    styleSheet: MarkdownStyleSheet.fromTheme(
                      Theme.of(context),
                    ).copyWith(
                      h1: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                      h2: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                      h3: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                      p: Theme.of(context).textTheme.bodyMedium,
                      strong: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      em: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                      listBullet: Theme.of(context).textTheme.bodyMedium,
                      // Style links prominently
                      a: const TextStyle(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                      // Style link bullets
                      blockquote: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Constants.spacingLarge),

              // Grounding sources (if available)
              if (response.metadata?['grounded'] == true &&
                  response.metadata?['sources'] != null &&
                  (response.metadata!['sources'] as List).isNotEmpty)
                Card(
                  color: AppColors.accentLight.withValues(alpha: 0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(Constants.spacingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.public,
                              color: AppColors.successGreen,
                              size: 20,
                            ),
                            const SizedBox(width: Constants.spacingSmall),
                            Text(
                              'Källhänvisningar från webben (Google Search)',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.successGreen,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Constants.spacingSmall),
                        Text(
                          'Informationen ovan baseras på följande aktuella källor:',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: Constants.spacingSmall),
                        ...((response.metadata!['sources'] as List).map((source) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Constants.spacingSmall / 2,
                            ),
                            child: InkWell(
                              onTap: () => _launchUrl(source['uri'], context),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.link,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: Constants.spacingSmall),
                                  Expanded(
                                    child: Text(
                                      source['title'] as String,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.primary,
                                            decoration: TextDecoration.underline,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })),
                      ],
                    ),
                  ),
                ),

              if (response.metadata?['grounded'] == true)
                const SizedBox(height: Constants.spacingMedium),

              // Disclaimer
              Container(
                padding: const EdgeInsets.all(Constants.spacingMedium),
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
                        response.metadata?['grounded'] == true
                            ? 'Informationen är hämtad från aktuella webbkällor via Google Search. Verifiera alltid rekommendationer genom att klicka på källhänvisningarna. Använd ditt kliniska omdöme.'
                            : 'AI-modellens kunskap kan vara föråldrad. Verifiera ALLTID rekommendationer genom att klicka på källhänvisningarna för aktuell information. Använd ditt kliniska omdöme.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getProviderIcon(String provider) {
    if (provider.toLowerCase().contains('claude')) {
      return Icons.psychology;
    }
    if (provider.toLowerCase().contains('gpt') ||
        provider.toLowerCase().contains('openai')) {
      return Icons.chat;
    }
    if (provider.toLowerCase().contains('gemini')) {
      return Icons.stars;
    }
    return Icons.help_outline;
  }

  /// Launch URL in browser
  Future<void> _launchUrl(String urlString, BuildContext context) async {
    try {
      final url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication, // Open in external browser
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Kunde inte öppna länk: $urlString'),
              backgroundColor: AppColors.danger,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fel vid öppning av länk: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }
}
