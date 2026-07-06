import 'package:app/core/app_background.dart';
import 'package:app/features/auth/domain/entities/user_entity.dart';
import 'package:app/features/auth/presentation/provider/auth_di_providers.dart';
import 'package:app/features/book/presentation/widget/category_widget.dart';
import 'package:app/features/home/presentation/widget/InsightsView.dart';
import 'package:app/features/home/presentation/widget/banner_widget.dart';
import 'package:app/features/home/presentation/widget/bottom_navigation.dart';
import 'package:app/features/home/presentation/widget/purchase_carousel.dart';
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
        titleSpacing: 16,
        title: Row(
          children: [
            Text(
              "For You",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 24,
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
                  color: Color.fromARGB(173, 0, 0, 0),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),
        ],
        
      ),
      bottomNavigationBar: BottomNavigation(),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                const BannerWidget(),

                const SizedBox(height: 20),

                const InsightsView() ,
                const SizedBox(height: 20),
                const PurchaseCarousel(),
                const SizedBox(height: 20),
                CategoryWidget(categoryId: "uYP6thI5CjeQtdyhAXzI",title: "New Arrivals",)

              ],
            ),
          ),
        ),
      ),
    );
  }
}
