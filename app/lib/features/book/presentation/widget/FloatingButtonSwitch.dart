import 'package:flutter/material.dart';

class FloatingModeSwitcher extends StatelessWidget {
  final bool isAudioMode;
  final ValueChanged<bool> onModeChanged;

  const FloatingModeSwitcher({
    super.key,
    required this.isAudioMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 220,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Premium deep charcoal slate
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 🏃 Animated Sliding Pill Indicator
          AnimatedAlign(
            duration: const Duration(milliseconds: 240),
            // curve: Curves.smoothStep,
            alignment: isAudioMode ? Alignment.centerRight : Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB), // Active brand accent blue
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
            ),
          ),

          // 🔘 Interactive Labels Layer
          Row(
            children: [
              // 📄 READ BUTTON CHANNEL
              Expanded(
                child: GestureDetector(
                  onTap: () => onModeChanged(false),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 18,
                          color: !isAudioMode ? Colors.white : Colors.white54,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Read",
                          style: TextStyle(
                            color: !isAudioMode ? Colors.white : Colors.white54,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 🎧 LISTEN BUTTON CHANNEL
              Expanded(
                child: GestureDetector(
                  onTap: () => onModeChanged(true),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.headset_rounded,
                          size: 18,
                          color: isAudioMode ? Colors.white : Colors.white54,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Listen",
                          style: TextStyle(
                            color: isAudioMode ? Colors.white : Colors.white54,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}