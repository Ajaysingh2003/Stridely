import 'package:app/features/auth/presentation/pages/signup_screen.dart';
import 'package:app/features/auth/presentation/widget/Login_form.dart';
import 'package:app/features/book/presentation/widget/book_cover.dart';
import 'package:app/features/book/presentation/widget/book_typography.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app/core/widget/back_button.dart';
import 'package:app/features/auth/presentation/widget/auth_header.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookView extends StatelessWidget {
  const BookView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        // height: 700,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              BookPoster(poster: "https://pub-db02f4666efb4ae9b337950ff0610772.r2.dev/ChatGPT%20Image%20Jun%207%2C%202026%20at%2006_28_18%20PM.png",),
              BookTypography(title: "Rich Dad Poor Dad",author: "ajay singh",)

          ],
        ),
      ),
    );
  }
}
