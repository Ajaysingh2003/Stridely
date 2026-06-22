import 'package:app/features/auth/presentation/pages/signup_screen.dart';
import 'package:app/features/auth/presentation/widget/Login_form.dart';
import 'package:app/features/book/presentation/widget/Book_hero.dart';
import 'package:app/features/book/presentation/widget/Book_tabs.dart';
import 'package:app/features/book/presentation/widget/Excerpt.dart';
import 'package:app/features/book/presentation/widget/book_Metadata.dart';
import 'package:app/features/book/presentation/widget/book_cover.dart';
import 'package:app/features/book/presentation/widget/book_typography.dart';
import 'package:app/features/book/presentation/widget/info_section.dart';
import 'package:app/features/book/presentation/widget/key_points.dart';
import 'package:app/features/book/presentation/widget/what_you_learn.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app/core/widget/back_button.dart';
import 'package:app/features/auth/presentation/widget/auth_header.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookView extends StatelessWidget {
  BookView({super.key});

  final List<String> excerpt = [
    "Never give up",
    "Focus on Your goal.",
    "Crucial strategic performance variable milestone."
  ]; 

  @override
  Widget build(BuildContext context) {
    
    const List<TagsType> tags = [
  TagsType(icon: Icons.highlight, tag: 'Ideation'),
  TagsType(icon: Icons.access_alarm, tag: 'Development'),
  TagsType(icon: Icons.access_alarm_rounded, tag: 'Launch'),
];
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Stack(
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              // const BookHero(),
              Padding(
                // padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                padding: EdgeInsetsGeometry.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    const BookTypography(
                      title: "Rich Dad ,Poor Dad",
                      description:"What the rich dad teach his children about the money - That the poor and the middle class Do not!",
                      chapterCount:11,
                      playMin:28,
                      ratting:4.7,
                      tags:tags,

                    ),
                    const SizedBox(height: 15,),
                 const  BookTab()
                    // const SizedBox(height: 20),
                    // const BookMetadata(),
                    // const SizedBox(height: 24),
                    // const InfoSection(
                    //   title: "What's inside?",
                    //   description: "Explore a revolutionary Japanese philosophy...",
                    // ),
                    // const SizedBox(height: 24),
                    // const Learning(
                    //   learning: [
                    //     "How emotions hijack the brain.",
                    //     "How emotions hijack the brain.",
                    //   ],
                    // ),
                    // const SizedBox(height: 24),
                    // KeyPoints(points: contents),
                    // const SizedBox(height: 24),
                    // const InfoSection(
                    //   title: "About JD. Vince", 
                    //   description: "JD vance is an american author...",
                    // ),
                    // const SizedBox(height: 24),
                    // const SizedBox(height: 12),
                    // Excerpt(excerpt: excerpt),
                    // const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),

          // Positioned(
          //   top: -40,    // 🚀 Changed from -200 to 0 so it's fully visible at the absolute top
          //   left: 0,   // Wall-to-wall anchoring
          //   right: 0,  // Wall-to-wall anchoring
          //   child: Container(
          //     color: Colors.amber,
          //     padding: const EdgeInsets.all(16), 
          //     child: const Text(
          //       "hii ajay",
          //       textAlign: TextAlign.center, 
          //       style: TextStyle(
          //         color: Colors.black,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}