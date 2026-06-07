import 'package:app/features/auth/presentation/pages/signup_screen.dart';
import 'package:app/features/auth/presentation/widget/Login_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app/core/widget/back_button.dart';
import 'package:app/features/auth/presentation/widget/auth_header.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
            const CustomBackButton(),
            const SizedBox(height: 25),
            const AuthHeader(title: "Welcome Back 👋" ,subText:"By Logging in , You agree to our "),
            const SizedBox(height: 20),
            const LoginForm(),
            SizedBox(height: 30),

            Row(
              children: [
                // Left Line
                Expanded(
                  child: Divider(
                    color: Colors.white24, // Matches your focused border color
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
                    color: Colors.white24,
                    thickness: 1,
                    indent: 16, // Space between text and the line
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation:
                      3, // Slightly increased for a better floating effect on dark backgrounds
                  shadowColor: Colors.black.withAlpha(
                    80,
                  ), // Softer shadow for a premium look
                  backgroundColor: const Color(0xFF222222),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  // Handle login logic here
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/images/google.svg", height: 20),
                    const SizedBox(width: 12),
                    Text(
                      "Login with Google",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight
                                .w500, // Semi-bold looks great on buttons
                            // color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 13),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation:
                      3, // Slightly increased for a better floating effect on dark backgrounds
                  shadowColor: Colors.black.withAlpha(
                    80,
                  ), // Softer shadow for a premium look
                  backgroundColor: const Color(0xFF222222),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  // Handle login logic here
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/apple.svg",
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Login with Apple",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight
                                .w500, // Semi-bold looks great on buttons
                            // color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
            Center(
              child: RichText(
                textAlign: TextAlign.center, // Centers the whole text block
                text: TextSpan(
                  // Base style inherited from your existing theme
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    color: Colors.grey, // Base text color
                  ),
                  children: [
                    const TextSpan(text: "Don't have an Accout ? "),

                    // 🚀 The clickable, styled link section
                    TextSpan(
                      text: " Signup",
                      style: const TextStyle(
                        color: Colors.white70, // Link color
                        fontWeight: FontWeight.bold, // Makes it bold
                        fontSize: 14,
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
                                    const SignupPage(),
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
