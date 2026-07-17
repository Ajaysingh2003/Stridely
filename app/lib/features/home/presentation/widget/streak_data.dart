import 'package:flutter/material.dart';

class StreakCard extends StatelessWidget {
  /// Current consecutive-day streak count.
  final int currentStreak;

  /// Longest streak ever achieved — shown as a quiet secondary stat.
  final int longestStreak;

  /// 7 entries, Monday → Sunday. true = day completed.
  final List<bool> weeklyProgress;

  /// Index (0–6) representing "today" within weeklyProgress, for highlighting.
  final int todayIndex;

  const StreakCard({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    required this.weeklyProgress,
    required this.todayIndex,
  }) : assert(weeklyProgress.length == 7);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface.withOpacity(0.35),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colors.onSurface.withOpacity(0.06),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.onSurface.withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _StreakFlame(colors: colors, isActive: currentStreak > 0),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$currentStreak',
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'day streak',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        longestStreak > currentStreak
                            ? 'Best: $longestStreak days'
                            : 'This is your best streak yet',
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _WeeklyRow(
              weeklyProgress: weeklyProgress,
              todayIndex: todayIndex,
              colors: colors,
              textTheme: textTheme,
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakFlame extends StatelessWidget {
  final ColorScheme colors;
  final bool isActive;

  const _StreakFlame({required this.colors, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final accent = isActive ? const Color(0xFFFF8A3D) : colors.onSurfaceVariant;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isActive
              ? [accent.withOpacity(0.18), accent.withOpacity(0.05)]
              : [
                  colors.onSurface.withOpacity(0.06),
                  colors.onSurface.withOpacity(0.02),
                ],
        ),
        border: Border.all(
          color: accent.withOpacity(isActive ? 0.2 : 0.08),
          width: 0.5,
        ),
      ),
      child: Icon(
        Icons.local_fire_department_rounded,
        size: 26,
        color: accent,
      ),
    );
  }
}

class _WeeklyRow extends StatelessWidget {
  final List<bool> weeklyProgress;
  final int todayIndex;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _WeeklyRow({
    required this.weeklyProgress,
    required this.todayIndex,
    required this.colors,
    required this.textTheme,
  });

  static const _labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final done = weeklyProgress[i];
        final isToday = i == todayIndex;

        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done
                    ? colors.onSurface.withOpacity(0.9)
                    : colors.onSurface.withOpacity(0.9),
                border: Border.all(
                  color: isToday
                      ? colors.primary.withOpacity(0.6)
                      : colors.onSurface.withOpacity(done ? 0 : 0.12),
                  width: isToday ? 1.2 : 0.5,
                ),
              ),
              child: done
                  ? Icon(Icons.check_rounded, size: 16, color: colors.surface)
                  : Icon(Icons.remove_sharp, size: 16, color: colors.surface),
            ),
            const SizedBox(height: 6),
            Text(
              _labels[i],
              style: textTheme.labelSmall?.copyWith(
                color: isToday
                    ? colors.primary
                    : colors.onSurfaceVariant.withOpacity(0.7),
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        );
      }),
    );
  }
}