import 'package:app/features/book/presentation/widget/book_cover.dart';
import 'package:flutter/material.dart';

class BookHero extends StatelessWidget {
  const BookHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        BookPoster(
          poster:
              "https://pub-db02f4666efb4ae9b337950ff0610772.r2.dev/ChatGPT%20Image%20Jun%207%2C%202026%20at%2006_28_18%20PM.png",
        ),
      ],
    );
  }
}