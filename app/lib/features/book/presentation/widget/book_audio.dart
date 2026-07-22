import 'package:app/features/book/presentation/provider/audio_provider.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/widget/book_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookAudioInterface extends ConsumerStatefulWidget {
  final String bookId;
  const BookAudioInterface({super.key, required this.bookId});

  @override
  ConsumerState<BookAudioInterface> createState() => _BookAudioInterfaceState();
}

class _BookAudioInterfaceState extends ConsumerState<BookAudioInterface>
    with SingleTickerProviderStateMixin {
  late final AnimationController _coverCtrl;
  late final Animation<double> _coverScale;

  static const _bg = Color.fromARGB(255, 29, 42, 54);
  // static const _bg = Color(0xFF0F1A24);
  static const _surface = Color.fromARGB(0, 19, 37, 54);
  static const _border = Color.fromARGB(0, 36, 55, 74);
  static const _accent = Color.fromARGB(205, 88, 179, 254);
  static const _accentDark = Color(0xFF3897E2);
  static const _textPrimary = Color(0xFFF5F7FA);
  static const _textMuted = Color.fromARGB(255, 102, 117, 130);

  @override
  void initState() {
    super.initState();
    _coverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _coverScale = Tween<double>(
      begin: 0.90,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _coverCtrl, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _coverCtrl.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double posterHeight = screenWidth * 0.62;
    final double posterWidth = posterHeight * 0.68;

    final bookAsync = ref.watch(singleBookProvider(widget.bookId));
    final audioChaptersState = ref.watch(
      bookContentChaptersControllerProvider(widget.bookId),
    );
    final chaptersList = audioChaptersState.chapters;

    
    return bookAsync.when(
      loading: () => const Scaffold(
        backgroundColor: _bg,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(_accent),
            strokeWidth: 3,
          ),
        ),
      ),
      error: (error, stackTrace) => const Scaffold(
        backgroundColor: _bg,
        body: Center(
          child: Icon(Icons.wifi_off_rounded, color: _textMuted, size: 44),
        ),
      ),
      data: (eitherResult) => eitherResult.fold(
        (failure) => Scaffold(
          backgroundColor: _bg,
          body: Center(
            child: Text(
              failure.message,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        (book) {
          if (audioChaptersState.isLoading && chaptersList.isEmpty) {
            return const Scaffold(
              backgroundColor: _bg,
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_accent),
                  strokeWidth: 3,
                ),
              ),
            );
          }

          final List<Map<String, String>> dynamicChapters =
              chaptersList.isNotEmpty
              ? chaptersList
              : [
                  {'title': book.title ?? 'Summary', 'startTimeMs': '0'},
                ];

          final params = AudioParams(
            bookId: widget.bookId,
            bookTitle: book.title ?? 'Audiobook Summary',
            audioUrl: book.audioUrl ?? '',
            chapters: dynamicChapters,
          );

          final audioState = ref.watch(audioPlayerProvider(params));
          final notifier = ref.read(audioPlayerProvider(params).notifier);

          final activeIndex = audioState.currentIndex.clamp(
            0,
            dynamicChapters.length - 1,
          );
          final activeTitle =
              audioState.currentChapter?.title ??
              dynamicChapters[activeIndex]['title'] ??
              'Untitled Chapter';
          final chapterCount = dynamicChapters.length;

          final List<int> timelineMarkersMs = dynamicChapters.map((ch) {
            return int.tryParse(ch['startTimeMs'] ?? '0') ?? 0;
          }).toList();

          audioState.isPlaying ? _coverCtrl.forward() : _coverCtrl.reverse();

          return Scaffold(
            backgroundColor: _bg,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                physics: const BouncingScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: _border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.24),
                        blurRadius: 34,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 4,
                        width: 46,
                        decoration: BoxDecoration(
                          color: _border,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      const SizedBox(height: 22),
                      ScaleTransition(
                        scale: _coverScale,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              width: posterWidth * 0.92,
                              height: posterHeight * 0.92,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                boxShadow: [
                                  BoxShadow(
                                    color: audioState.isPlaying
                                        ? _accent.withValues(alpha: 0.24)
                                        : Colors.black.withValues(alpha: 0.18),
                                    blurRadius: audioState.isPlaying ? 46 : 24,
                                    spreadRadius: audioState.isPlaying ? 4 : 0,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: posterWidth,
                              height: posterHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: _border, width: 2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: BookPoster(poster: book.bookCover),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        // Smoothly animate layout width matching shifts
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        child: SizedBox(
                          // ── 🎯 THE FIX: Forces the column to fill the layout width ──
                          key: ValueKey(
                            'title_${activeIndex}_${activeTitle.hashCode}_${audioState.isPlaying}',
                          ),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Aligns elements to the left edge
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                activeTitle,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      wordSpacing: 2,
                                    ),
                                textAlign: TextAlign
                                    .start, // Aligns text baseline left
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 7),
                              Text(
                                book.title ?? "Untitled book",
                                style: const TextStyle(
                                  color: _textMuted,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),

                      // ── Clean Deterministic Unified Timeline Progress Slider ──
                      _ContinuousSeekBar(
                        progress: audioState.progress,
                        totalDurationMs: audioState.duration.inMilliseconds,
                        timelineMarkersMs: timelineMarkersMs,
                        onChanged:
                            audioState.isLoading ||
                                audioState.duration.inMilliseconds <= 0
                            ? null
                            : notifier.seekToProgress,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _fmt(audioState.position),
                              style: const TextStyle(
                                color: _textMuted,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: Text(
                                '${activeIndex + 1}/$chapterCount',
                                key: ValueKey('chapter-count-$activeIndex'),
                                style: const TextStyle(
                                  color: _textMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Text(
                              _fmt(audioState.duration),
                              style: const TextStyle(
                                color: _textMuted,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),

                      if (audioState.error != null) ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            audioState.error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _TactileButton(
                            icon: Icons.keyboard_double_arrow_left_rounded,
                            onTap: notifier.skipToPreviousChapter,
                            isSecondary: true,
                          ),
                          const SizedBox(width: 12),
                          _TactileButton(
                            icon: Icons.replay_10_rounded,
                            onTap: notifier.skipBackward,
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: notifier.playPause,
                            child: Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                color: audioState.isLoading
                                    ? _border
                                    : _accentDark,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: audioState.isLoading
                                      ? _border
                                      : _accent,
                                  shape: BoxShape.circle,
                                ),
                                child: audioState.isLoading
                                    ? const Padding(
                                        padding: EdgeInsets.all(24),
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : Icon(
                                        audioState.isPlaying
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 46,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          _TactileButton(
                            icon: Icons.forward_10_rounded,
                            onTap: notifier.skipForward,
                          ),
                          const SizedBox(width: 12),
                          _TactileButton(
                            icon: Icons.keyboard_double_arrow_right_rounded,
                            onTap: notifier.skipToNextChapter,
                            isSecondary: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _bg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [0.75, 1.0, 1.25, 1.5, 2.0].map((s) {
                            final active = s == audioState.speed;
                            return GestureDetector(
                              onTap: () => notifier.setSpeed(s),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: active ? _accent : Colors.transparent,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  '${s}x',
                                  style: TextStyle(
                                    color: active ? Colors.white : _textMuted,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TactileButton extends StatelessWidget {
  const _TactileButton({
    required this.icon,
    required this.onTap,
    this.isSecondary = false,
  });
  final IconData icon;
  final VoidCallback onTap;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isSecondary ? 44 : 50,
        height: isSecondary ? 44 : 50,
        decoration: const BoxDecoration(
          color: Color(0xFF24374A),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.only(bottom: 3),
        child: Container(
          decoration: BoxDecoration(
            color: isSecondary
                ? const Color(0xFF111C26)
                : const Color(0xFF162533),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isSecondary
                ? const Color(0xFF6B7E8F)
                : const Color(0xFFEEEEEE),
            size: isSecondary ? 18 : 22,
          ),
        ),
      ),
    );
  }
}

class _ContinuousSeekBar extends StatefulWidget {
  const _ContinuousSeekBar({
    required this.progress,
    required this.totalDurationMs,
    required this.timelineMarkersMs,
    required this.onChanged,
  });

  final double progress;
  final int totalDurationMs;
  final List<int> timelineMarkersMs;
  final ValueChanged<double>? onChanged;

  @override
  State<_ContinuousSeekBar> createState() => _ContinuousSeekBarState();
}

class _ContinuousSeekBarState extends State<_ContinuousSeekBar> {
  double? _localDragProgress;

  void _setLocalProgress(Offset localPosition, BoxConstraints constraints) {
    if (widget.onChanged == null || constraints.maxWidth <= 0) return;
    final prg = (localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0);
    setState(() => _localDragProgress = prg);
  }

  void _commitSeek() {
    if (widget.onChanged == null || _localDragProgress == null) return;
    final prg = _localDragProgress!;
    setState(() => _localDragProgress = null);
    widget.onChanged!(prg);
  }

  @override
  Widget build(BuildContext context) {
    final displayProgress = _localDragProgress ?? widget.progress;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            _setLocalProgress(details.localPosition, constraints);
            _commitSeek();
          },
          onHorizontalDragStart: (details) =>
              _setLocalProgress(details.localPosition, constraints),
          onHorizontalDragUpdate: (details) =>
              _setLocalProgress(details.localPosition, constraints),
          onHorizontalDragEnd: (_) => _commitSeek(),
          onHorizontalDragCancel: () {
            if (mounted) setState(() => _localDragProgress = null);
          },
          child: SizedBox(
            height: 38,
            width: double.infinity,
            child: CustomPaint(
              painter: _ContinuousSeekBarPainter(
                progress: displayProgress,
                totalDurationMs: widget.totalDurationMs,
                timelineMarkersMs: widget.timelineMarkersMs,
                enabled: widget.onChanged != null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ContinuousSeekBarPainter extends CustomPainter {
  const _ContinuousSeekBarPainter({
    required this.progress,
    required this.totalDurationMs,
    required this.timelineMarkersMs,
    required this.enabled,
  });

  final double progress;
  final int totalDurationMs;
  final List<int> timelineMarkersMs;
  final bool enabled;

  static const _trackHeight = 5.0;
  static const _dotRadius = 3.5;
  static const _thumbRadius = 9.0;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final progressX = progress * size.width;

    final basePaint = Paint()
      ..color = const Color(0xFF8BA3B8).withValues(alpha: 0.24)
      ..style = PaintingStyle.fill;
    final activePaint = Paint()
      ..color = enabled ? const Color(0xFF58B4FE) : const Color(0xFF8BA3B8)
      ..style = PaintingStyle.fill;
    final dotPaint = Paint()
      ..color = const Color(0xFF0F1A24)
      ..style = PaintingStyle.fill;

    // Background track rail bounding frame
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          0,
          centerY - (_trackHeight / 2),
          size.width,
          centerY + (_trackHeight / 2),
        ),
        const Radius.circular(99),
      ),
      basePaint,
    );

    // Active fill timeline tracking path
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          0,
          centerY - (_trackHeight / 2),
          progressX,
          centerY + (_trackHeight / 2),
        ),
        const Radius.circular(99),
      ),
      activePaint,
    );

    // Draw fixed timeline interval chapter dots based on relative timestamp values
    if (totalDurationMs > 0) {
      for (final markerMs in timelineMarkersMs) {
        if (markerMs == 0)
          continue; // Ignore the absolute beginning of track index
        final double ratio = markerMs / totalDurationMs;
        final double dotX = ratio * size.width;

        if (dotX > 0 && dotX < size.width) {
          canvas.drawCircle(Offset(dotX, centerY), _dotRadius, dotPaint);
        }
      }
    }

    // Audio handle tracking thumb
    canvas.drawCircle(Offset(progressX, centerY), _thumbRadius, activePaint);
    canvas.drawCircle(
      Offset(progressX, centerY),
      _thumbRadius * 0.45,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _ContinuousSeekBarPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.totalDurationMs != totalDurationMs ||
        oldDelegate.timelineMarkersMs != timelineMarkersMs ||
        oldDelegate.enabled != enabled;
  }
}
