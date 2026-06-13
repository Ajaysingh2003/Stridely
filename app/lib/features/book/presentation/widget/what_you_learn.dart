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
      decoration: BoxDecoration(
        // 1. A premium, solid dark charcoal that layers beautifully over absolute black
        color: const Color(0xFF222020),

        // 2. A smooth, intentional curve
        borderRadius: BorderRadius.circular(16),

        // 3. A razor-thin, elegant border that feels integrated rather than pasted on
        border: Border.all(
          color: Colors.white.withAlpha(
            30,
          ),
          width: 1.0, 
        ),

        // 4. A soft, deep shadow to give the component physical presence and depth
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(100),
            blurRadius: 24,
            offset: const Offset(0, 8), // Pushes shadow downward
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsetsGeometry.directional(
          top: 16,
          start: 20,
          end: 20,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You'll Learn",
              style: Theme.of(context).textTheme.headlineMedium,
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
            color: Color.fromARGB(234, 59, 123, 251),
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
