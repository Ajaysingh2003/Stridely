import 'package:flutter/material.dart';

class KeyPoint {
  final String id;
  final String text;
  KeyPoint({required this.id, required this.text});
}

class KeyPoints extends StatelessWidget {
  // final List<KeyPoint> points;
  final List<Map<String, String>> points;
  const KeyPoints({super.key, required this.points});

  // 🚀 UNIFIED DESIGN: Standardized shared divider property configuration
  static const Divider _sharedDivider = Divider(
    height: 1,
    thickness: 0.3,
    color: Color.fromARGB(99, 69, 68, 68),
  );

  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.fromLTRB(0, 30, 0, 0),child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──────────────────────────────────────
        if (points.isNotEmpty)
          ...points.asMap().entries.map(
            (entry) => ContentButton(
              point: entry.value,
              index: entry.key,
              isLast: entry.key == points.length - 1,
              sharedDivider: _sharedDivider,
            ),
          ),
      ],
    ),);
    
  }
}

class ContentButton extends StatefulWidget {
  // final KeyPoint point;
  final Map<String, String> point;
  final int index;
  final bool isLast;
  final Widget sharedDivider;

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
          padding: const EdgeInsets.fromLTRB(0,14,14,14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Index number
              SizedBox(
                width: 28,
                child: Text(
                  '${widget.index + 1}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
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
                  widget.point["title"] ?? "",
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    // color: const Color.fromARGB(168, 255, 255, 255),
                    fontSize: 16,
                    wordSpacing: 5,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
               Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.primary,
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
