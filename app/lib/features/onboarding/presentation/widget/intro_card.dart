import 'dart:ui';

import 'package:flutter/material.dart';

class StridelyIntroCard extends StatelessWidget {
  const StridelyIntroCard();

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 128,
            padding: const EdgeInsets.fromLTRB(11, 10, 11, 11),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff4A8FE8).withValues(alpha: 0.14),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header row — logo + name
                Row(
                  children: [
                    // App icon mini
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xff6EC8FF), Color(0xff4A8FE8)],
                        ),
                      ),
                      child: const Center(
                        child: Text('S',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            )),
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stridely',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xff12284A),
                          ),
                        ),
                        Text(
                          'Your reading companion',
                          style: TextStyle(
                            fontSize: 7.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff6B7E8F),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 9),

                // Divider
                Container(
                  height: 1,
                  color: const Color(0xffE8F0F8),
                ),

                const SizedBox(height: 9),

                // What we do — three micro points
                _MicroPoint(
                  icon: '📚',
                  text: 'Book summaries in 15 min',
                ),
                const SizedBox(height: 5),
                _MicroPoint(
                  icon: '🎧',
                  text: 'Listen or read, your way',
                ),
                const SizedBox(height: 5),
                _MicroPoint(
                  icon: '✦',
                  text: 'Save highlights & excerpts',
                  accent: true,
                ),
              ],
            ),
          ),
        ),
      );
}

class _MicroPoint extends StatelessWidget {
  const _MicroPoint({
    required this.icon,
    required this.text,
    this.accent = false,
  });

  final String icon;
  final String text;
  final bool accent;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: accent
                  ? const Color(0xff4A8FE8)
                  : const Color(0xff3A5068),
            ),
          ),
        ],
      );
}