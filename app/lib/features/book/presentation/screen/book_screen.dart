import 'package:app/core/app_background.dart';
import 'package:app/core/widget/back_button.dart';
import 'package:app/features/book/presentation/widget/book_view.dart';
import 'package:flutter/material.dart';
import 'package:app/features/home/presentation/widget/banner_widget.dart';

import 'package:app/features/auth/presentation/widget/LoginView.dart';

class BookPage extends StatefulWidget {
  final String title;
  const BookPage({super.key,this.title="Rich Dad Poor Dad"});

  // final title="";

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {

  // const _BookPageState({super.k})
  @override
  Widget build(BuildContext context) {
    // int _currentIndex = 0;
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xFF191717),
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
            IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,

                size: 21,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
               widget.title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: const Color.fromARGB(211, 255, 255, 255),
                  // fontStyle: FontStyle.italic,
                  // fontSize: 20,
                ),
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(
                    Icons.bookmark_add,
                    color: Colors.white70,
                    
                    size: 25,
                  ),
                ),
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(
                    Icons.ios_share,
                    color: Colors.white70,

                    size: 25,
                  ),
                ),
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(
                    Icons.file_download_outlined,
                    color: Colors.white70,

                    size: 30,
                  ),
                ),
              ],
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
      // extendBodyBehindAppBar: true,
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // space for bottom nav
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // LoginView()
                BookView()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
