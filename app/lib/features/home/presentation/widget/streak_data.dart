import 'package:flutter/material.dart';

class WeeklyMomentumCard extends StatefulWidget {
  const WeeklyMomentumCard({super.key});

  @override
  State<WeeklyMomentumCard> createState() => _WeeklyMomentumCardState();
}

class _WeeklyMomentumCardState extends State<WeeklyMomentumCard> {
  bool _isExpanded = false;
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header — tappable to expand tip
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "DAILY TIP",
                            style: textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFFF6B35),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const Spacer(),
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "Walk 15 minutes after eating",
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A1A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    // Expandable detail
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Studies show this simple habit reduces post-meal glucose spikes by up to 15%. No gym required — just lace up and go.",
                          style: textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF666666),
                            height: 1.5,
                          ),
                        ),
                      ),
                      crossFadeState: _isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 250),
                    ),
                  ],
                ),
              ),
            ),

            // Like action — gives feedback
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () => setState(() => _liked = !_liked),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _liked
                        ? const Color(0xFFFF6B35).withOpacity(0.08)
                        : const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedScale(
                        scale: _liked ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 150),
                        child: Icon(
                          _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 18,
                          color: _liked ? const Color(0xFFFF6B35) : const Color(0xFFAAAAAA),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _liked ? "Saved for later" : "Save this tip",
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _liked ? const Color(0xFFFF6B35) : const Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Friends + action
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  // Tappable friend row — shows who's active
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Show friend activity sheet
                        _showFriendSheet(context);
                      },
                      child: Row(
                        children: [
                          _FriendDots(),
                          const SizedBox(width: 12),
                          Text(
                            "3 friends active",
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: Color(0xFFCCCCCC),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Main action — starts a session
                  FilledButton(
                    onPressed: () {
                      // Navigate to active session
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Join",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFriendSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Active now",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            _FriendTile(name: "James D.", activity: "Walking • 12 min", color: Colors.indigo),
            _FriendTile(name: "Anna M.", activity: "Jogging • 8 min", color: Colors.teal),
            _FriendTile(name: "Sam R.", activity: "Cycling • 24 min", color: Colors.amber),
          ],
        ),
      ),
    );
  }
}

class _FriendDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 28,
      child: Stack(
        children: [
          _Dot(color: Colors.indigo, left: 0),
          _Dot(color: Colors.teal, left: 16),
          _Dot(color: Colors.amber, left: 32),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double left;

  const _Dot({required this.color, required this.left});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

class _FriendTile extends StatelessWidget {
  final String name;
  final String activity;
  final Color color;

  const _FriendTile({
    required this.name,
    required this.activity,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(activity, style: const TextStyle(color: Color(0xFF999999), fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Color(0xFFCCCCCC)),
        ],
      ),
    );
  }
}