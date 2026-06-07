import 'package:app/features/home/presentation/pages/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subText;
  const AuthHeader({super.key, required this.title,required this.subText});

  void _openTermsPage(BuildContext context) {
    print("Navigate to Terms of Use Page or Open Web URL");

    Navigator.push(
      context,
      MaterialPageRoute(
        // Replace 'TermsView()' with the actual class name of your terms screen file
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              // fontStyle: FontStyle.italic,
              height: 1.2,
              fontSize: 26,
            ),
          ),
          SizedBox(height: 8),

          // Text(
          //   "By Logging in,you agree to our Terms of Use",
          //   style: Theme.of(context).textTheme.bodyMedium,
          // ),
          RichText(
            textAlign: TextAlign.center, // Centers the whole text block
            text: TextSpan(
              // Base style inherited from your existing theme
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey, // Base text color
              ),
              children: [
                 TextSpan(text: subText),

 
                // 🚀 The clickable, styled link section
                TextSpan(
                  text: " Terms of Use",
                  style: const TextStyle(
                    color: Colors.white70, // Link color
                    fontWeight: FontWeight.bold, // Makes it bold
                    decoration:
                        TextDecoration.underline, // Adds a link underline
                  ),
                  // 🚀 Captures the tap gesture event natively
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openTermsPage(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
