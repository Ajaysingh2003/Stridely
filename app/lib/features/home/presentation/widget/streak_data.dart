import 'package:flutter/material.dart';

class StreakCard extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final List<bool> weeklyProgress;
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
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFEEEEEE),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _FlameIcon(currentStreak: currentStreak),
                  const SizedBox(width: 16),
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
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                                color: const Color(0xFF1A1A1A),
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              currentStreak == 1 ? 'day streak' : 'day streak',
                              style: textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF999999),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Longest: $longestStreak days',
                          style: textTheme.labelSmall?.copyWith(
                            color: const Color(0xFFBBBBBB),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _WeekRow(
                weeklyProgress: weeklyProgress,
                todayIndex: todayIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlameIcon extends StatelessWidget {
  final int currentStreak;

  const _FlameIcon({required this.currentStreak});

  @override
  Widget build(BuildContext context) {
    final isActive = currentStreak > 0;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFFFFF5F0) : const Color(0xFFF7F7F7),
      ),
      child: Center(
        child: Icon(
          Icons.local_fire_department_rounded,
          size: 26,
          color: isActive ? const Color(0xFFFF6B35) : const Color(0xFFD0D0D0),
        ),
      ),
    );
  }
}

class _WeekRow extends StatelessWidget {
  final List<bool> weeklyProgress;
  final int todayIndex;

  const _WeekRow({
    required this.weeklyProgress,
    required this.todayIndex,
  });

  static const _labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final done = weeklyProgress[i];
        final isToday = i == todayIndex;

        return _DayItem(
          label: _labels[i],
          done: done,
          isToday: isToday,
        );
      }),
    );
  }
}

class _DayItem extends StatelessWidget {
  final String label;
  final bool done;
  final bool isToday;

  const _DayItem({
    required this.label,
    required this.done,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? const Color(0xFF1A1A1A) : const Color(0xFFF2F2F2),
            border: Border.all(
              color: isToday
                  ? const Color(0xFFFF6B35)
                  : done
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFFE5E5E5),
              width: isToday ? 2 : 1,
            ),
          ),
          child: done
              ? const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: Colors.white,
                )
              : null,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isToday ? const Color(0xFFFF6B35) : const Color(0xFFAAAAAA),
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                fontSize: 11,
              ),
        ),
      ],
    );
  }
}