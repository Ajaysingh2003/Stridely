import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

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
        onPressed: () => Navigator.maybePop(context),
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Theme.of(context).colorScheme.onSecondary,
          size: 18,
        ),
      ),
    );
  }
}
