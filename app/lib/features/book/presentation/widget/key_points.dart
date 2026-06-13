import 'package:flutter/material.dart';

class KeyPoint {
  final String id;
  final String text;
  KeyPoint({required this.id, required this.text});
}

class KeyPoints extends StatelessWidget {
  final List<KeyPoint> points;
  const KeyPoints({super.key, required this.points});

  // 🚀 UNIFIED DESIGN: Standardized shared divider property configuration
  static const Divider _sharedDivider = Divider(
    height: 1, 
    thickness: 0.3, 
    color: Color.fromARGB(101, 255, 255, 255),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──────────────────────────────────────
        Text(
          "Key Points",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        
        // 🚀 MATCHED: Main title separator now matches item dividers perfectly
        _sharedDivider, 
        
        if (points.isNotEmpty)
          ...points.asMap().entries.map(
                (entry) => ContentButton(
                  point: entry.value,
                  index: entry.key,
                  isLast: entry.key == points.length - 1,
                  sharedDivider: _sharedDivider, // Passes down global style rule
                ),
              ),
      ],
    );
  }
}

class ContentButton extends StatefulWidget {
  final KeyPoint point;
  final int index;
  final bool isLast;
  final Widget sharedDivider; // 🚀 Accept the standardized divider element

  const ContentButton({
    super.key,
    required this.point,
    required this.index,
    required this.isLast,
    required this.sharedDivider,
  });

  @override
  State<ContentButton> createState() => _ContentButtonState();
}

class _ContentButtonState extends State<ContentButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          // 🚀 FIXED: Kept padding on content row, but moved divider outside its bounds
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Index number
              SizedBox(
                width: 28,
                child: Text(
                  '${widget.index + 1}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 12),
              // Point text
              Expanded(
                child: Text(
                  widget.point.text,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        // color: const Color.fromARGB(168, 255, 255, 255),
                        height: 1.5,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: Color.fromARGB(168, 255, 255, 255),
                size: 25,
              ),
            ],
          ),
        ),
        // 🚀 FIXED: Divider renders outside of padding box context, aligning flush edge-to-edge
         widget.sharedDivider,
      ],
    );
  }
}