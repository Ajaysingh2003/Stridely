import 'dart:ffi';

import 'package:app/features/home/presentation/pages/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Learning extends StatelessWidget {
  final List<String> learning;
  const Learning({super.key, required this.learning});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 300,
      
      child: Padding(
        padding: const EdgeInsetsGeometry.directional(
          top: 30,
          start: 0,
          end: 0,
          bottom: 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You'll Learn",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 10),
            ...learning
                .map((e) => BuildLearnItem(title: e, context: context))
                .toList(),
          ],
        ),
      ),
    );
  }
}

class BuildLearnItem extends StatefulWidget {
  final String title;
  final BuildContext context;
  const BuildLearnItem({super.key, required this.title, required this.context});

  @override
  State<BuildLearnItem> createState() => _BuildLearnItemState();
}

class _BuildLearnItemState extends State<BuildLearnItem> {
  // Optional state variable: tracks if the user checked off this learning point
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Elegant blue checkmark icon for each item
          const Icon(
            Icons.check,
            color: Color.fromARGB(234, 98, 147, 246),
            size: 25,
          ),
          const SizedBox(width: 12),

          // The actual text content
          Expanded(
            child: Text(
              widget.title, // 🚀 Fixed: Accessing the title using 'widget.'
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                // color: const Color.fromARGB(229, 255, 255, 255),
                // fontSize: 16,
                // height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
