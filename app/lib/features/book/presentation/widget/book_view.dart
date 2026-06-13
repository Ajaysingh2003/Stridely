import 'package:app/features/auth/presentation/pages/signup_screen.dart';
import 'package:app/features/auth/presentation/widget/Login_form.dart';
import 'package:app/features/book/presentation/widget/Book_hero.dart';
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

  final List<KeyPoint> contents = [
    KeyPoint(id: "kp1", text: "First key concept overview data marker."),
    KeyPoint(id: "kp2", text: "Crucial strategic performance variable milestone."),
    KeyPoint(id: "kp3", text: "Final data summary calculation metric context."),
  ];

  final List<String> excerpt = [
    "Never give up",
    "Focus on Your goal.",
    "Crucial strategic performance variable milestone."
  ]; 

  @override
  Widget build(BuildContext context) {
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Stack(
        children: [
           Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const BookHero(),

          Positioned(child: Row(
            
          )),


          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                const SizedBox(height: 5),
                const BookTypography(
                  title: "Never Split the Difference",
                  author: "Daniel Goleman, PhD",
                ),
                const SizedBox(height: 20),
                const BookMetadata(),
                const SizedBox(height: 24),
                const InfoSection(
                  title: "What's inside?",
                  description: "Explore a revolutionary Japanese philosophy...",
                ),
                const SizedBox(height: 24),
                const Learning(
                  learning: [
                    "How emotions hijack the brain.",
                    "How emotions hijack the brain.",
                  ],
                ),
                const SizedBox(height: 24),
                KeyPoints(points: contents),
                const SizedBox(height: 24),
                const InfoSection(
                  title: "About JD. Vince", 
                  description: "JD vance is an american author...",
                ),

                const SizedBox(height: 24),

         
          const SizedBox(height: 12),
          
          Excerpt(excerpt: excerpt),
          
          const SizedBox(height: 20),
              ],
            ),
          ),
          
          
        ],
      ),
        ],
      )
    );
  }
}