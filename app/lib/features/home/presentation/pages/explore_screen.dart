import 'package:app/core/app_background.dart';
import 'package:app/core/func/Navigate.dart';
import 'package:app/features/book/presentation/widget/CategoryMain.dart';
import 'package:app/features/book/presentation/widget/category_widget.dart';
import 'package:app/features/book/presentation/widget/getting_all_books.dart';
import 'package:app/features/home/presentation/widget/Collections.dart';
import 'package:app/features/home/presentation/widget/Collections_View.dart';
import 'package:app/features/home/presentation/widget/Daily_picks.dart';
import 'package:app/features/home/presentation/widget/Tops_chart.dart';
import 'package:app/features/home/presentation/widget/bottom_navigation.dart';
import 'package:app/features/home/presentation/widget/search_widget.dart';
import 'package:app/features/home/presentation/widget/side_menu.dart';
import 'package:app/features/subscriptions/providers/subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class ExplorePage extends ConsumerWidget {
  const ExplorePage({super.key});

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Explore",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
                onTap: () async {
                  // print("looking for offering...");

                  try {
                    // 1. Await the future to turn Future<Offerings?> into a raw Offerings? object
                    final Offerings? offerings = await ref
                        .read(subscriptionActionsProvider)
                        .fetchOfferings();

                    // print("Resolved Offerings data object: $offerings");

                    // 2. Safely check if offerings is not null, then access the .all map
                    if (offerings != null &&
                        offerings.all["yearly_offer"] != null) {
                      final PaywallResult result =
                          await RevenueCatUI.presentPaywall(
                            displayCloseButton: true,
                            offering: offerings.all["yearly_offer"]!,
                          );
                    } else {
                      // print(
                      //   "⚠️ Target offering ID 'yearly_offer' not found in dashboard.",
                      // );
                    }
                  } catch (e) {
                    // print("❌ Failed to resolve network offerings: $e");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(
                    8,
                  ), // Padding around the asset image
                  decoration: BoxDecoration(
                    // color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,

                  ),
                  child: Image.asset(
                    "assets/images/gift1.png",
                    width: 45,
                    height: 45,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
        ],
      ),
      // bottomNavigationBar: BottomNavigation(currentIndex:2, onTap: (index) => moveTo(context, const ExplorePage(), "explore-screen") ,),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 10),
                SearchWidget(),
                SizedBox(height: 10),
                CategoryScroll(),
                // SizedBox(height: 10),
                DailyPicks(),
                // BooksList(categoryId: "uYP6thI5CjeQtdyhAXzI",title: "Daily Pick's",),
                // SizedBox(height: 20),
                BooksList(categoryId: "uYP6thI5CjeQtdyhAXzI",title: "Self Growth",),
                SizedBox(height: 20),
                Collections(),
                SizedBox(height: 20),
                BooksList(categoryId: "lNFEAQfx4yhRnnZwQso0",title: "Amazon Most Read",),
                SizedBox(height: 20),
                BookListView(embedded: true,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
