import 'package:app/core/app_background.dart';
import 'package:flutter/material.dart';
import 'package:app/features/home/presentation/widget/banner_widget.dart';

import 'package:app/features/auth/presentation/widget/LoginView.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // int _currentIndex = 0;
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xFF191717),
      // extendBodyBehindAppBar: true,
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // space for bottom nav
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                LoginView()
    
              ],
            ),
          ),
        ),
      ),
    );
  }
}
