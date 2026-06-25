import 'package:app/features/book/presentation/widget/book_cover.dart';
import 'package:flutter/material.dart';

class BookHero extends StatelessWidget {
  
  final String bookCover; 
  const BookHero({super.key, required this.bookCover});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BookPoster(
          poster: bookCover
        ),
    );
    
  }
}