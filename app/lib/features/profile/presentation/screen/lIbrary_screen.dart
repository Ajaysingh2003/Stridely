import 'package:app/core/app_background.dart';
import 'package:app/features/home/presentation/widget/side_menu.dart';
import 'package:app/features/profile/presentation/widget/Library_books.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final themeColors = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      drawer: const SideMenu(),
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        scrolledUnderElevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Library",
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 6,
                    ), // Subtle space between text baseline and the underline
                    // 🚀 The Stylish Gradient Underline Dash
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .primary,
                            Theme.of(context).colorScheme.primary, 
                            Colors
                                .transparent,
                          ],
                          stops: const [0.0, 0.9, 1.0],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcIn,
                      child: Container(
                        width:64, 
                        height:4,
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.circular(2,), 
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16),
        //     child: Builder(
        //       builder: (context) => IconButton(
        //         icon: const Icon(
        //           Icons.person_outline_rounded,
        //           size: 36,
        //           color: Color.fromARGB(173, 0, 0, 0),
        //         ),
        //         onPressed: () {
        //           Scaffold.of(context).openDrawer();
        //         },
        //       ),
        //     ),
        //   ),
        // ],
      ),
      // bottomNavigationBar: BottomNavigation(currentIndex:4, onTap: (index) => moveTo(context, const ProfileScreen(), "profile-screen") ,),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LibraryBooks()
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigation(currentIndex: 3,onTap: (value) => {},),
    );
  }
}
