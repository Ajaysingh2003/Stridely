import 'package:app/features/home/presentation/pages/home_screen.dart';
import 'package:app/features/home/presentation/widget/bottom_navigation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class AuthHeader extends StatelessWidget {
  final String title;
  final String subText;
  const AuthHeader({super.key, required this.title, required this.subText});

  // void _openTermsPage(BuildContext context) {
    

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       // Replace 'TermsView()' with the actual class name of your terms screen file
  //       builder: (context) => const MainNavigationShell(initialIndex: 0,),
  //     ),
  //   );
  // }



  Future<void> _openTermsPage(BuildContext context) async {
  // 1. Define your terms and conditions web URL target link
  final Uri url = Uri.parse('https://sites.google.com/view/booksly-privacy-policy?usp=sharing');

  try {
    // 2. Verify if the device platform has a browser component ready to open the link
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        // 💡 InAppBrowserConfiguration launch mode opens the site inside 
        // a secure overlay sheet right inside your app instead of leaving it.
        mode: LaunchMode.inAppBrowserView, 
      );
    } else {
      throw 'Could not launch absolute target path: $url';
    }
  } catch (e) {
    // Fallback error feedback helper layout if the redirect pipeline fails
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open Terms page layout: $e')),
      );
    }
  }
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
              // color: Colors.white,

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
                // color: Colors.grey, // Base text color
              ),
              children: [
                TextSpan(text: subText,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0x9F000000)
                )),

                TextSpan(
                  text: "Privacy Policy",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,

                    decorationColor: Theme.of(context).colorScheme.onSurface,

                    decorationThickness: 1.5,
                  ),
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
