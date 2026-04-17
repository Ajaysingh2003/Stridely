import 'package:app/core/app_background.dart';
import 'package:app/features/home/presentation/widget/banner_widget.dart';
import 'package:app/features/home/presentation/widget/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
      automaticallyImplyLeading:false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        scrolledUnderElevation: 0,

        titleSpacing: 16, // controls left spacing globally

        title: Image.asset("images/codex-color.png", height: 30),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Builder(
              builder: (context) =>
                 IconButton(
              icon: SvgPicture.asset(
                "images/menu.svg",
                color: Colors.white,
                height: 30,
              ),
              onPressed: () {
                 Scaffold.of(context).openDrawer();
              },
            ),
                  
            ),
          ),
        ],
      ),
      body: AppBackground(child: Column(children: const [BannerWidget()])),
    );
  }
}
