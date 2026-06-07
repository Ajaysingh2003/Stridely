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
          Text("Summary"),
          Text(title),
          Text(author),
        ],
      ),
    );
  }
}
