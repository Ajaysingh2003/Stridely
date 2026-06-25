import 'package:app/core/app_background.dart';
import 'package:app/features/auth/domain/entities/user_entity.dart';
import 'package:app/features/auth/presentation/provider/auth_di_providers.dart';
import 'package:app/features/home/presentation/widget/banner_widget.dart';
import 'package:app/features/home/presentation/widget/bottom_navigation.dart';
import 'package:app/features/home/presentation/widget/side_menu.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = Theme.of(context).colorScheme;

    // 🚀 1. Listen to the live stream directly.
    // When Firebase logs out, this triggers an automatic redraw instantly!
    final authStateAsync = ref.watch(authStateStreamProvider);
    final UserEntity? user = ref.watch(authStateStreamProvider).value;
    print('🔥 RAW FIRESTORE DATA: $user');
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
        titleSpacing: 26,
        title: Row(
          children: [
            Image.asset("assets/images/codex-color.png", height: 30),
            const SizedBox(width: 10),
            Text(
              "Stridely",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.black,
                fontStyle: FontStyle.italic,
                fontSize: 17,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Builder(
              builder: (context) => IconButton(
                icon: const Icon(
                  Icons.sort,
                  size: 36,
                  color: Color.fromARGB(174, 255, 255, 255),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF000000),
                  Color(0xFF3B7BFB),
                  Color(0xFF000000),
                ],
                stops: [0, 0.5, 1],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🚀 2. Use Riverpod's pattern matcher to display or clear data
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: authStateAsync.when(
                    loading: () => const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (err, stack) => Text(
                      'Error: $err',
                      style: const TextStyle(color: Colors.red),
                    ),
                    data: (user) {
                      if (user == null) {
                        return Text(
                          'Browsing as Guest',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email: ${user.email}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'UID: ${user.isPremium}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white70),
                          ),
                        ], 
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () =>
                        ref.read(authControllerProvider.notifier).logout(),
                    child: const Text("logout"),
                  ),
                ),

                const BannerWidget(),
                const SizedBox(height: 20),
                const BannerWidget(),
                const SizedBox(height: 20),
                Text(
                  'UID: ${user?.email}',
                  style: TextStyle(color: Colors.red),
                ),
                const BannerWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
