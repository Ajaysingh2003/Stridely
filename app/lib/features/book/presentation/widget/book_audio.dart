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


  static const _bg          = Color(0xFF0F1A24);          
  static const _surface     = Color(0xFF162533);          
  static const _border      = Color(0xFF24374A);        
  static const _accent      = Color(0xFF58B4FE);         
  static const _accentDark  = Color(0xFF3897E2);         
  static const _textPrimary = Color(0xFFF5F7FA);         
  static const _textMuted   = Color(0xFF8BA3B8);

  @override
  void initState() {
    super.initState();
    _coverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _coverScale = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(parent: _coverCtrl, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _coverCtrl.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double posterHeight = screenWidth * 0.62;
    final double posterWidth = posterHeight * 0.68;
    
    // 1. Load the core book info 
    final bookAsync = ref.watch(singleBookProvider(widget.bookId));

    // 2. Fetch your dynamic timeline list of chapter audios
    final chaptersList = ref.watch(bookContentAudiosControllerProvider(widget.bookId)).audios;

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
      error: (_, __) => const Scaffold(
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
              style: const TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        (book) {
          // Guard against empty lists by adding a fallback parameter configuration
          final safeChapters = chaptersList.isNotEmpty 
              ? chaptersList 
              : [
                  {
                    'uid': widget.bookId,
                    'title': book?.title ?? 'Chapter 1',
                    'audioUrl': book?.audioUrl ?? ''
                  }
                ];

          // Pass the complete chapter list into our AudioParams collection model
          final params = AudioParams(
            chapters: safeChapters,
            initialIndex: 0,
          );
          
          final audioState = ref.watch(audioPlayerProvider(params));
          final notifier   = ref.read(audioPlayerProvider(params).notifier);

          audioState.isPlaying ? _coverCtrl.forward() : _coverCtrl.reverse();
          
          return Scaffold(
            backgroundColor: _bg,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    ScaleTransition(
                      scale: _coverScale,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            width: posterWidth * 0.9,
                            height: posterHeight * 0.9,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: audioState.isPlaying 
                                      ? _accent.withValues(alpha: 0.22) 
                                      : _accent.withValues(alpha: 0.02),
                                  blurRadius: audioState.isPlaying ? 40 : 16,
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

                    const SizedBox(height: 28),

                    // ── Book Typography Metadata ─────────────────────────────
                    Text(
                      book?.title ?? "Untitled Book",
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.4,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      book.author.name,
                      style: const TextStyle(
                        color: _textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // ── Audio Progression Canvas (Seek Bar) ──────────────────
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 6,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                          // pressedThumbRadius: 10,
                        ),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                        activeTrackColor: _accent,
                        inactiveTrackColor: _surface,
                        thumbColor: _textPrimary,
                        overlayColor: _accent.withValues(alpha: 0.2),
                      ),
                      child: Slider(
                        value: audioState.progress,
                        onChanged: (v) => notifier.seekTo(
                          Duration(
                            milliseconds: (v * audioState.duration.inMilliseconds).toInt(),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _fmt(audioState.position),
                            style: const TextStyle(color: _textMuted, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          if (audioState.isBuffering)
                            const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(color: _accent, strokeWidth: 2),
                            ),
                          Text(
                            _fmt(audioState.duration),
                            style: const TextStyle(color: _textMuted, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Playback Controls & Leap Engine ──────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Leap Backward 60s
                        _TactileButton(
                          icon: Icons.fast_rewind_rounded,
                          onTap: () => notifier.seekTo(audioState.position - const Duration(seconds: 60)),
                          isSecondary: true,
                        ),
                        const SizedBox(width: 14),
                        
                        // Regular Skip 10s back
                        _TactileButton(
                          icon: Icons.replay_10_rounded,
                          onTap: notifier.skipBackward,
                        ),
                        const SizedBox(width: 18),

                        // Master Center Play Trigger
                        GestureDetector(
                          onTap: notifier.playPause,
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              color: audioState.isLoading ? _surface : _accentDark,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.only(bottom: 6), // 3D Elevation
                            child: Container(
                              decoration: BoxDecoration(
                                color: audioState.isLoading ? _surface : _accent,
                                shape: BoxShape.circle,
                              ),
                              child: audioState.isLoading
                                  ? const Padding(
                                      padding: EdgeInsets.all(24),
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                    )
                                  : Icon(
                                      audioState.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 46,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),

                        // Regular Skip 10s forward
                        _TactileButton(
                          icon: Icons.forward_10_rounded,
                          onTap: notifier.skipForward,
                        ),
                        const SizedBox(width: 14),

                        // Leap Forward 60s
                        _TactileButton(
                          icon: Icons.fast_forward_rounded,
                          onTap: () => notifier.seekTo(audioState.position + const Duration(seconds: 60)),
                          isSecondary: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // ── Tactical Speed Selector Panel ────────────────────────
                    const Text(
                      'PLAYBACK SPEED',
                      style: TextStyle(
                        color: _textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _border, width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [0.75, 1.0, 1.25, 1.5, 2.0].map((s) {
                          final active = s == audioState.speed;
                          return GestureDetector(
                            onTap: () => notifier.setSpeed(s),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                    const SizedBox(height: 32),
                  ],
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
        padding: const EdgeInsets.only(bottom: 3), // Displacement depth
        child: Container(
          decoration: BoxDecoration(
            color: isSecondary ? const Color(0xFF111C26) : const Color(0xFF162533),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isSecondary ? const Color(0xFF6B7E8F) : const Color(0xFFEEEEEE),
            size: isSecondary ? 18 : 22,
          ),
        ),
      ),
    );
  }
}