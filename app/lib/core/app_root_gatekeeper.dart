import 'package:app/core/providers/shared_providers.dart';
import 'package:app/features/auth/presentation/pages/login_screen.dart';
import 'package:app/features/auth/presentation/provider/auth_di_providers.dart';
import 'package:app/features/home/presentation/widget/bottom_navigation.dart';
import 'package:app/features/onboarding/presentation/screen/onBoarding_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppRootGatekeeper extends ConsumerWidget {
  const AppRootGatekeeper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Monitor active login state loops
    // final authState = ref.watch(authControllerProvider);
    final authState = ref.watch(authStateStreamProvider);
    // 2. Extract our local onboarding completion flag right away

    final hasSeenOnboarding = ref
        .read(onboardingStorageProvider)
        .checkHasSeenOnboarding();
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return authState.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF000000),
        body: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF58B4FE)),
            ),
          ),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        backgroundColor: const Color(0xFF000000),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Something went wrong',
              style: textTheme.bodyMedium?.copyWith(color: colors.error),
            ),
          ),
        ),
      ),
      data: (user) {
        if (user?.email != "") {
          return const MainNavigationShell(initialIndex: 0,); // Logged in? Go directly to the app features.
        }
        
        // Unauthenticated users land here:
        if (!hasSeenOnboarding) {
          return const OnboardingScreen(); // Never seen it? Show Onboarding.
        }
        
        return const LoginPage();
      },
    );
  }
}
