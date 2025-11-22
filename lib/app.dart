import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/screens/provider_selection_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/query/screens/home_screen.dart';
import 'shared/theme/app_theme.dart';
import 'shared/theme/app_colors.dart';

class KliniskAIApp extends ConsumerWidget {
  const KliniskAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Klinisk AI Assistent',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: authState.when(
        data: (isAuthenticated) {
          return isAuthenticated
              ? const HomeScreen()
              : const ProviderSelectionScreen();
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ),
        error: (error, stack) => const ProviderSelectionScreen(),
      ),
    );
  }
}
