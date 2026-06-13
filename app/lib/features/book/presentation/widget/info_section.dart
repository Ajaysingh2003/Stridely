import 'package:app/features/home/presentation/pages/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  final String title;
  final String description;
  const InfoSection({super.key, required this.title,required this.description});

 

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              // color: Colors.white,
              // // fontStyle: FontStyle.italic,
              // height: 1.2,
              // fontSize: 26,
            ),
          ),
          SizedBox(height: 8),

          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              // fontSize: 16,
              letterSpacing: 1.05
            ),
          ),
         
        ],
      ),
    );
  }
}
