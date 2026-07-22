import 'package:app/core/app_background.dart';
import 'package:app/core/func/Navigate.dart';
import 'package:app/features/book/presentation/widget/category_widget.dart';
import 'package:app/features/book/presentation/widget/getting_all_books.dart';
import 'package:app/features/home/presentation/widget/Collections.dart';
import 'package:app/features/home/presentation/widget/InsightsView.dart';
import 'package:app/features/home/presentation/widget/Tops_chart.dart';
import 'package:app/features/home/presentation/widget/banner_widget.dart';
import 'package:app/features/home/presentation/widget/purchase_carousel.dart';
import 'package:app/features/home/presentation/widget/side_menu.dart';
import 'package:app/features/profile/presentation/screen/lIbrary_screen.dart';
import 'package:app/features/subscriptions/providers/subscription_provider.dart';
import 'package:purchases_ui_flutter/paywall_result.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:app/features/auth/presentation/provider/auth_di_providers.dart';
// import 'package:dartz/dartz.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomeScreenState();
}





class _HomeScreenState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    
    // 🚀 Trigger the permission dialog as soon as the screen is fully loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRequestNotificationPermission();
    });
  }

  Future<void> _checkAndRequestNotificationPermission() async {
    // 1. Check the current status of notification permissions
    var status = await Permission.notification.status;
    
    // 2. If the user hasn't been asked yet, request it explicitly
    if (status.isDenied) {
      // This triggers the native system modal sheet prompt
      final result = await Permission.notification.request();
      
      if (result.isGranted) {
        debugPrint("🔔 Notification permissions granted successfully!");
        // TODO: Initialize your push token registration sync here (e.g., Firebase Messaging)
      } else {
        debugPrint("⚠️ Notification permissions denied by user.");
      }
    } 
    // 3. Optional: Handle cases where the user permanently denied permissions previously
    else if (status.isPermanentlyDenied) {
      debugPrint("❌ Notification permissions are permanently denied in system settings.");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      "For You",
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
        actions: [
          IconButton(
            onPressed: () {
              moveTo(context, LibraryScreen(), "library-stored-books");
            },
            icon: Icon(
              Icons.bookmark_add_sharp,
              size: 34,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: AppBackground(
        child: Stack(
          children: [
            // LAYER 1: Scrollable Feed Content (No internal positioning hacks)
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  bottom: 120,
                ), // Added padding so content clears the button
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PurchaseCarousel(),
                    const SizedBox(height: 20),
                    const BannerWidget(),
                    const SizedBox(height: 20),
                    const InsightsView(),
                    const SizedBox(height: 20),
                    CategoryWidget(
                      categoryId: "uYP6thI5CjeQtdyhAXzI",
                      title: "New Arrivals",
                    ),
                    BooksList(
                      categoryId: "uYP6thI5CjeQtdyhAXzI",
                      title: "Self Growth",
                    ),
                    const SizedBox(height: 20),
                    Collections(),
                    const SizedBox(height: 20),
                    BooksList(
                      categoryId: "lNFEAQfx4yhRnnZwQso0",
                      title: "Amazon Most Read",
                    ),
                    const SizedBox(height: 20),
                    BookListView(embedded: true),
                  ],
                ),
              ),
            ),

            // LAYER 2: Completely static Floating Gift Button
            Positioned(
              bottom: 160,
              right: 20,
              child: GestureDetector(
                onTap: () async {
                  try {
                    // 1. Await the future to turn Future<Offerings?> into a raw Offerings? object
                    final Offerings? offerings = await ref
                        .read(subscriptionActionsProvider)
                        .fetchOfferings();

                    // 2. Safely check if offerings is not null, then access the .all map
                    if (offerings != null &&
                        offerings.all["yearly_offer"] != null) {
                      final PaywallResult result =
                          await RevenueCatUI.presentPaywall(
                            displayCloseButton: true,
                            offering: offerings.all["yearly_offer"]!,
                          );
                    } else {}
                  } catch (e) {}
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
                    "assets/images/gift.png",
                    width: 45,
                    height: 45,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
