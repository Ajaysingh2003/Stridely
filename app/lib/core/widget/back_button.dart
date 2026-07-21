import 'package:app/core/func/Navigate.dart';
import 'package:app/features/home/presentation/pages/home_screen.dart';
import 'package:app/features/home/presentation/widget/bottom_navigation.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    this.isLoginScreen = false,
  });

  final bool isLoginScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 33, 33, 33).withValues(alpha: 0.15),
            blurRadius: 1,
            spreadRadius: 0.2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        onPressed: !isLoginScreen
            ? () => Navigator.maybePop(context)
            : () => Navigator.push(
      context,
      MaterialPageRoute(
        // Replace 'TermsView()' with the actual class name of your terms screen file
        builder: (context) => const MainNavigationShell(initialIndex: 0,),
      ),
    ),
        icon: Icon(
          !isLoginScreen ? Icons.arrow_back_ios_new : Icons.close_outlined,
          color: Theme.of(context).colorScheme.onSecondary,
          size: 18,
        ),
      ),
    );
  }
}