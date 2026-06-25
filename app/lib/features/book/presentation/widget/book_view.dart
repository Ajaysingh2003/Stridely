import 'package:app/features/auth/presentation/pages/signup_screen.dart';
import 'package:app/features/auth/presentation/widget/Login_form.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';
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
// import 'package:app/features/auth/presentation/widget/auth_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class BookView extends ConsumerWidget {
  final BookEntity book;
  BookView({super.key, required this.book});

  final List<String> excerpt = [
    "Never give up",
    "Focus on Your goal.",
    "Crucial strategic performance variable milestone.",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {

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
                    BookTypography(
                      title: book.title ?? "",
                      description: book.description ?? "",
                      chapterCount: book.chapterCount,
                      playMin: book.duration,
                      ratting: book.rating,
                      tags: book.tags,
                    ),
                    const SizedBox(height: 15),
                     BookTab(book: book,),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
