import 'package:app/features/auth/presentation/pages/login_screen.dart';
import 'package:app/features/home/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/auth/presentation/provider/auth_di_providers.dart';
import 'package:app/features/auth/presentation/widget/LoginView.dart';
// import 'package:app/features/home/presentation/widget/HomeDashboardView.dart'; // Your app's main landing view

class AuthGatekeeper extends ConsumerWidget {
  const AuthGatekeeper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🛠️ 1. Watch the live Firebase Auth Stream Provider
    final authStateStream = ref.watch(authStateStreamProvider);
  
    // 2. Use .when to react dynamically to stream emission states
    return authStateStream.when(
      // 🎉 Case A: Stream connected successfully
      data: (userEntity) {
        if (userEntity != null) {
          // 🔓 User is logged in! Send them into the core application
          return const HomePage();
        }
        // 🔒 No active session found. Send them to the authentication forms
        return const LoginPage();
      },
      
      // ⏳ Case B: App is reading initial session parameters from disk on bootup
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      
      // ❌ Case C: Stream connection error fallback
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Authentication Stream Error: $error'),
        ),
      ),
    );
  }
}