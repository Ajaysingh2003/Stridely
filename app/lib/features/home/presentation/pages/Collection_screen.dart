import 'package:app/core/app_background.dart';
import 'package:app/core/func/Navigate.dart';
// import 'package:app/core/func/Navigate.dart';
import 'package:app/features/home/presentation/widget/Collections_View.dart';
// import 'package:app/features/home/presentation/widget/bottom_navigation.dart';
import 'package:app/features/home/presentation/widget/side_menu.dart';
import 'package:app/features/profile/presentation/screen/lIbrary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollectionPage extends ConsumerWidget {
  
  const CollectionPage({super.key});

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
                      "Collection",
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
                        width:84, 
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
        actions: [
          IconButton(
            onPressed: () {
              moveTo(context, LibraryScreen(), "library-stored-books");
            },
            icon: Icon(
              Icons
                  .bookmark_add_sharp,
              size: 34,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigation(currentIndex:3, onTap: (index) => moveTo(context, const CollectionPage(), "collection-screen") ,),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CollectionsView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}