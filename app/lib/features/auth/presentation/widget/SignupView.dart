import 'package:app/features/auth/presentation/pages/login_screen.dart';
import 'package:app/features/auth/presentation/pages/signup_screen.dart';
import 'package:app/features/auth/presentation/provider/auth_di_providers.dart';
import 'package:app/features/auth/presentation/widget/Login_form.dart';
import 'package:app/features/auth/presentation/widget/signup_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app/core/widget/back_button.dart';
import 'package:app/features/auth/presentation/widget/auth_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignupView extends ConsumerWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomBackButton(),
            const SizedBox(height: 25),
            const AuthHeader(
              title: "Register Account",
              subText: "By signing up, you accept our ",
            ),
            const SizedBox(height: 20),
            const SignupForm(),
            SizedBox(height: 30),

            Row(
              children: [
                // Left Line
                Expanded(
                  child: Divider(
                    color: Color(
                      0x397C7B7B,
                    ), // Matches your focused border color
                    thickness: 1, // Line thickness
                    endIndent: 16, // Space between line and the text
                  ),
                ),

                // Middle Text
                const Text(
                  'Or',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),

                // Right Line
                Expanded(
                  child: Divider(
                    color: Color(0x397C7B7B),
                    thickness: 1,
                    indent: 16, // Space between text and the line
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        33,
                        33,
                        33,
                      ).withOpacity(0.1),
                      blurRadius: 1,
                      spreadRadius: 1.2,
                      offset: Offset.zero,
                    ),
                  ],
                ),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () {
                    ref
                        .read(authControllerProvider.notifier)
                        .signInWithGoogle();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/google.svg", height: 20),
                      const SizedBox(width: 12),
                      Text(
                        "Signin with Google",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              // fontSize: 17,
                              fontWeight: FontWeight.w500,
                              // color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 13),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        33,
                        33,
                        33,
                      ).withOpacity(0.1),
                      blurRadius: 1,
                      spreadRadius: 1.2,
                      offset: Offset.zero,
                    ),
                  ],
                ),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () {
                    // Handle login logic here
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/apple.svg", height: 20),
                      const SizedBox(width: 12),
                      Text(
                        "Signin with Google",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              // fontSize: 17,
                              fontWeight: FontWeight.w500,
                              // color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
            Center(
              child: RichText(
                textAlign: TextAlign.center, // Centers the whole text block
                text: TextSpan(
                  // Base style inherited from your existing theme
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 12,
                    color: Color.fromARGB(154, 21, 21, 21),
                  ),
                  children: [
                    const TextSpan(text: "Don't have an Accout ? "),

                    // 🚀 The clickable, styled link section
                    TextSpan(
                      text: " Signin",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold, // Makes it bold
                        fontSize: 12,
                        decoration:
                            TextDecoration.underline, // Adds a link underline
                      ),
                      // 🚀 Captures the tap gesture event natively
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const LoginPage(),
                            transitionDuration: const Duration(
                              milliseconds: 550,
                            ),
                            reverseTransitionDuration: const Duration(
                              milliseconds: 500,
                            ), // Speed when going back
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  // Slides from right (1.0, 0.0) to center (0.0, 0.0)

                                  final begin = const Offset(1.5, 0.0);
                                  final end = Offset.zero;
                                  final tween = Tween(begin: begin, end: end);

                                  // Makes the animation start fast and slow down gently (smooth look)
                                  final curvedAnimation = CurvedAnimation(
                                    parent: animation,

                                    curve: Curves.easeInOutCubic,
                                  );

                                  return SlideTransition(
                                    position: tween.animate(curvedAnimation),

                                    child: child,
                                  );
                                },
                          ),
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
