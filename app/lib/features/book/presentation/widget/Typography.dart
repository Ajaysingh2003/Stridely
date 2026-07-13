import 'package:flutter/material.dart';

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
