import 'package:audio_session/audio_session.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';


class CurrentChapter {
  final String uid;
  final String title;
  final String audioUrl;
  final int index;

  const CurrentChapter({
    required this.uid,
    required this.title,
    required this.audioUrl,
    required this.index,
  });
}

class AudioPlayerState extends Equatable {
  final bool isPlaying;
  final bool isLoading;
  final bool isBuffering;
  final Duration position;
  final Duration duration;
  final double speed;
  final int currentIndex;
  final String? error;
  final CurrentChapter?  currentChapters;

  const AudioPlayerState({
    this.currentChapters,
    this.isPlaying = false,
    this.isLoading = true,
    this.isBuffering = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.speed = 1.0,
    this.currentIndex = 0,
    this.error,
  });

  AudioPlayerState copyWith({
    bool? isPlaying,
    bool? isLoading,
    bool? isBuffering,
    Duration? position,
    Duration? duration,
    double? speed,
    int? currentIndex,
    String? error,
  }) =>
      AudioPlayerState(
        isPlaying: isPlaying ?? this.isPlaying,
        isLoading: isLoading ?? this.isLoading,
        isBuffering: isBuffering ?? this.isBuffering,
        position: position ?? this.position,
        duration: duration ?? this.duration,
        speed: speed ?? this.speed,
        currentIndex: currentIndex ?? this.currentIndex,
        error: error,
      );

  double get progress =>
      duration.inMilliseconds > 0
          ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
          : 0.0;

  @override
  List<Object?> get props =>
      [isPlaying, isLoading, isBuffering, position, duration, speed, currentIndex, error];
}

// ── Params — Rewritten to handle a list of Maps cleanly ───────────────────────
class AudioParams extends Equatable {
  final List<Map<String, String>> chapters;
  final int initialIndex;

  const AudioParams({
    required this.chapters,
    this.initialIndex = 0,
  });

  @override
  List<Object?> get props => [chapters, initialIndex];
}

// ── Notifier ──────────────────────────────────────────────────────────────────
class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  final AudioPlayer _player;
  final AudioParams params;
  bool _isInitialized = false;

  AudioPlayerNotifier(this._player, this.params)
      : super(AudioPlayerState(currentIndex: params.initialIndex)) {
    _init();
  }

  Future<void> _init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());

      if (!mounted) return;

      // Listen to play/pause and load states safely
      _player.playerStateStream.listen((s) {
        if (!mounted) return;
        state = state.copyWith(
          isPlaying: s.playing,
          isLoading: s.processingState == ProcessingState.loading ||
              s.processingState == ProcessingState.buffering,
          isBuffering: s.processingState == ProcessingState.buffering,
        );
      });

      // Listen to layout slider progression positions
      _player.positionStream.listen((p) {
        if (!mounted) return;
        state = state.copyWith(position: p);
      });

      // Listen to duration updates (fires per-track inside the playlist context)
      _player.durationStream.listen((d) {
        if (!mounted) return;
        if (d != null) state = state.copyWith(duration: d);
      });

      // Track index changes when tracks shift automatically
      _player.currentIndexStream.listen((index) {
        if (!mounted || index == null) return;
        state = state.copyWith(currentIndex: index);
      });

      // ── Build the Blinkist-Style Playlist Engine ───────────────────────────
      final playlist = ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: params.chapters.map((chapter) {
          final urlStr = chapter['audioUrl'] ?? '';
          return AudioSource.uri(
            Uri.parse(urlStr),
            tag: MediaItem(
              id: urlStr,
              title: chapter['title'] ?? 'Untitled Chapter',
              album: 'Book Summary',
            ),
          );
        }).toList(),
      );

      // Mount the entire pipeline cluster cleanly
      await _player.setAudioSource(playlist, initialIndex: params.initialIndex);

      if (!mounted) return;
      state = state.copyWith(isLoading: false, speed: _player.speed);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load audio playlist: $e',
      );
    }
  }

  Future<void> playPause() async {
    _player.playing ? await _player.pause() : await _player.play();
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
  }

  Future<void> skipForward() async {
    final target = state.position + const Duration(seconds: 10);
    await _player.seek(target > state.duration ? state.duration : target);
  }

  Future<void> skipBackward() async {
    final target = state.position - const Duration(seconds: 10);
    await _player.seek(target < Duration.zero ? Duration.zero : target);
  }

  // Next Track Skip (Used by the double-arrow layout widgets)
  Future<void> skipToNextChapter() async {
    if (_player.hasNext) {
      await _player.seekToNext();
    }
  }

  // Previous Track Skip (Used by the double-arrow layout widgets)
  Future<void> skipToPreviousChapter() async {
    if (_player.hasPrevious) {
      await _player.seekToPrevious();
    }
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
    if (!mounted) return;
    state = state.copyWith(speed: speed);
  }

  @override
  void dispose() {
    _player.stop(); 
    super.dispose();
  }
}


final audioPlayerProvider = StateNotifierProvider.autoDispose
    .family<AudioPlayerNotifier, AudioPlayerState, AudioParams>(
  (ref, params) {
    final player = AudioPlayer();
    
    // Explicit clean disposal handshake execution when UI context changes
    ref.onDispose(() => player.dispose());
    
    return AudioPlayerNotifier(player, params);
  },
);