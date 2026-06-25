import 'dart:ffi';

import 'package:app/features/book/domain/entity/tags_type.dart';
import 'package:flutter/material.dart';


class BookTypography extends StatelessWidget {
  final String title;
  final String description;
  final int chapterCount;
  final int playMin;
  final double ratting;
  final List<TagsType> tags;

  const BookTypography({super.key, required this.title,required this.chapterCount,required this.description,required this.playMin,required this.ratting, required this.tags});

  @override 
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookSubText(chapterCount: chapterCount, playMin: playMin),
          const SizedBox(height: 3,),
          Typography(title: title,description: description,),
          const SizedBox(height: 10,),
          Tags(ratting: ratting, tags: tags),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

class BookSubText extends StatelessWidget {
  final int chapterCount;
  final int playMin;

  const BookSubText({
    super.key, 
    required this.chapterCount, 
    required this.playMin,
  });

  @override
  Widget build(BuildContext context) {
    // Shared styled text variable block to keep the tree clean
    final textStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Colors.grey[600],
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
         Text(
          '$playMin min', 
          style: Theme.of(context).textTheme.bodySmall,
        ),
       
        

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Text(
            '•', 
            style: textStyle.copyWith(color: Colors.grey[400]),
          ),
        ),
        
         Text(
          '$chapterCount Chapters', 
          style: Theme.of(context).textTheme.bodySmall,
        ),
        // 3. Play Duration Minutes Display Text Node
       
      ],
    );
  }
}




class Typography extends StatelessWidget {
  final String title; 
  final String description; 
  const Typography ({required this.title,required this.description });

  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,style: Theme.of(context).textTheme.headlineLarge,),
        const SizedBox(height: 6,),
        Text(description,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontStyle: FontStyle.italic,
          fontSize: 15,
          wordSpacing: 2,
          color: Colors.grey[700]
        ),)
      ],
    );
  }
}





// import 'package:flutter/material.dart';

class Tags extends StatelessWidget {
  final double ratting;
  final List<TagsType> tags;

  const Tags({
    super.key,
    required this.ratting,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          
          // 1. Rating Block
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                // border: Border.all(color: const Color.fromARGB(80, 56, 56, 56).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    ratting.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary
                    )
                  ),
                ],
              ),
            ),
          ),

          // 2. Dynamic Tags Array
          ...tags.map((item) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.iconData, 
                      size: 16, 
                      color:  Theme.of(context).colorScheme.onSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.tag,
                      style:Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary
                      )
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

        ],
      ),
    );
  }
}