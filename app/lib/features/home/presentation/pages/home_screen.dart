import 'package:app/core/app_background.dart';
import 'package:app/features/home/presentation/widget/banner_widget.dart';
import 'package:app/features/home/presentation/widget/bottom_navigation.dart';
import 'package:app/features/home/presentation/widget/side_menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // int _currentIndex = 0;
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
            SizedBox(width: 10,),
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
                icon: Icon(
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
          preferredSize: Size.fromHeight(2),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF000000),
                  const Color(0xFF3B7BFB),
                  const Color(0xFF000000),
                ],
                stops: [0, 0.5, 1],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigation(),

      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // space for bottom nav
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                BannerWidget(),
                SizedBox(height: 20),
                BannerWidget(),
                SizedBox(height: 20),
                BannerWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
