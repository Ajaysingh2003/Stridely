import 'package:app/core/app_background.dart';
import 'package:app/core/func/Navigate.dart';
// import 'package:app/features/bookmark/notifier/notifier.dart';
// import 'package:app/core/func/Navigate.dart';
// import 'package:app/features/home/presentation/widget/Collections_View.dart';
// import 'package:app/features/home/presentation/widget/bottom_navigation.dart';
import 'package:app/features/home/presentation/widget/side_menu.dart';
// import 'package:app/features/home/presentation/widget/streak_data.dart';
import 'package:app/features/profile/presentation/screen/LIbrary_screen.dart';
import 'package:app/features/profile/presentation/screen/account_setting_page.dart';
import 'package:app/features/profile/presentation/widget/saved_book.dart';
import 'package:app/features/profile/presentation/widget/user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final themeColors = Theme.of(context).colorScheme;
// final int totalSaved = ref.watch(bookmarkNotifierProvider.notifier).getBookmarkIds();
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
            Text(
              "Profile",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 24,
              ),
            ),
          ],
        ),
      actions: [
        
      ],
      ),
      // bottomNavigationBar: BottomNavigation(currentIndex:4, onTap: (index) => moveTo(context, const ProfileScreen(), "profile-screen") ,),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserView(),
                SizedBox(height: 18),
                SavedBookEntry(onTap: ()=>moveTo(context, LibraryScreen(), "library-stored-books"),),
                AccountSettingsView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
