import 'package:flutter/material.dart';

class BookTypography extends StatelessWidget {
  final String title;
  final String author;
  const BookTypography({super.key, required this.title, required this.author});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "SUMMARY",

            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            author,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              // fontWeight: FontWeight.w500,
              fontSize: 12
            ),
          ),
        ],
      ),
    );
  }
}
