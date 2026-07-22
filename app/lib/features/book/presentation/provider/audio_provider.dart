import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:just_audio/just_audio.dart';

class CurrentChapter extends Equatable {
  final String title;
  final int startTimeMs;
  final int index;

  const CurrentChapter({
    required this.title,
    required this.startTimeMs,
    required this.index,
  });

  @override
  List<Object?> get props => [title, startTimeMs, index];
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
  final CurrentChapter? currentChapter;

  const AudioPlayerState({
    this.currentChapter,
    this.isPlaying = false,
    this.isLoading = true,
    this.isBuffering = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.speed = 1.0,
    this.currentIndex = 0,
    this.error,
  });

  double get progress => duration.inMilliseconds > 0
      ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
      : 0.0;

  AudioPlayerState copyWith({
    bool? isPlaying,
    bool? isLoading,
    bool? isBuffering,
    Duration? position,
    Duration? duration,
    double? speed,
    int? currentIndex,
    CurrentChapter? currentChapter,
    String? error,
  }) => AudioPlayerState(
    currentChapter: currentChapter ?? this.currentChapter,
    isPlaying: isPlaying ?? this.isPlaying,
    isLoading: isLoading ?? this.isLoading,
    isBuffering: isBuffering ?? this.isBuffering,
    position: position ?? this.position,
    duration: duration ?? this.duration,
    speed: speed ?? this.speed,
    currentIndex: currentIndex ?? this.currentIndex,
    error: error,
  );

  @override
  List<Object?> get props => [
    currentChapter,
    isPlaying,
    isLoading,
    isBuffering,
    position,
    duration,
    speed,
    currentIndex,
    error,
  ];
}

class AudioParams extends Equatable {
  final String bookId;
  final String bookTitle;
  final String audioUrl;
  // Each map contains 'title' and 'startTimeMs' (string representation of an int)
  final List<Map<String, String>> chapters;

  const AudioParams({
    required this.bookId,
    required this.bookTitle,
    required this.audioUrl,
    required this.chapters,
  });

  @override
  List<Object?> get props => [
        bookId,
        bookTitle,
        audioUrl,
        chapters.map((c) => '${c['title']}_${c['startTimeMs']}').join(','),
      ];
}

// Single global AudioPlayer instance
final globalAudioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  final AudioPlayer _player;
  final AudioParams params;
  bool _disposed = false;

  StreamSubscription? _playerStateSub;
  StreamSubscription? _positionSub;
  StreamSubscription? _durationSub;

  AudioPlayerNotifier(this._player, this.params) : super(const AudioPlayerState()) {
    _init();
  }

  void _safeUpdate(AudioPlayerState newState) {
    if (_disposed) return;
    state = newState;
  }

  Future<void> _init() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());
      await session.setActive(true);

      await _playerStateSub?.cancel();
      await _positionSub?.cancel();
      await _durationSub?.cancel();

      // 1. Monitor Playback State
      _playerStateSub = _player.playerStateStream.listen((s) {
        if (_disposed) return;
        _safeUpdate(state.copyWith(
          isPlaying: s.playing,
          isLoading: s.processingState == ProcessingState.loading || s.processingState == ProcessingState.idle,
          isBuffering: s.processingState == ProcessingState.buffering,
        ));
      });

      // 2. Continuous Single Stream Position Listener
      _positionSub = _player.positionStream.listen((p) {
        if (_disposed) return;
        
        // Dynamically deduce the active chapter index based on current playback milliseconds
        final currentMs = p.inMilliseconds;
        int activeIdx = 0;

        for (int i = 0; i < params.chapters.length; i++) {
          final startMs = int.tryParse(params.chapters[i]['startTimeMs'] ?? '0') ?? 0;
          if (currentMs >= startMs) {
            activeIdx = i;
          } else {
            break;
          }
        }

        final ch = params.chapters[activeIdx];
        _safeUpdate(state.copyWith(
          position: p,
          currentIndex: activeIdx,
          currentChapter: CurrentChapter(
            title: ch['title'] ?? 'Untitled Chapter',
            startTimeMs: int.tryParse(ch['startTimeMs'] ?? '0') ?? 0,
            index: activeIdx,
          ),
        ));
      });

      // 3. Audio Stream Total Duration Listener
      _durationSub = _player.durationStream.listen((d) {
        if (_disposed || d == null) return;
        _safeUpdate(state.copyWith(duration: d));
      });

      // 4. Setup plain Audio Source (no background service dependency)
      final String url = params.audioUrl.trim();
      if (url.isEmpty) {
        _safeUpdate(state.copyWith(isLoading: false, error: 'No audio URL available for this book.'));
        return;
      }

      final AudioSource source;
      if (url.startsWith('assets/') || url.startsWith('asset/')) {
        source = AudioSource.asset(url);
      } else {
        source = AudioSource.uri(Uri.parse(url));
      }

      _safeUpdate(state.copyWith(isLoading: true, error: null));
      await _player.setAudioSource(source);
      _safeUpdate(state.copyWith(isLoading: false, error: null));

    } catch (e) {
      
      _safeUpdate(state.copyWith(isLoading: false, error: 'Failed to initialize audio: $e'));
    }
  }

  Future<void> playPause() async {
    try {
      if (_player.playing) {
        await _player.pause();
      } else {
        await _player.play();
      }
    } catch (e) {
      _safeUpdate(state.copyWith(error: 'Playback error: $e'));
    }
  }

  Future<void> seekToProgress(double globalProgress) async {
    final targetMs = (state.duration.inMilliseconds * globalProgress.clamp(0.0, 1.0)).round();
    await _player.seek(Duration(milliseconds: targetMs));
  }

  Future<void> seekToChapter(int index) async {
    if (index < 0 || index >= params.chapters.length) return;
    final startMs = int.tryParse(params.chapters[index]['startTimeMs'] ?? '0') ?? 0;
    await _player.seek(Duration(milliseconds: startMs));
  }

  Future<void> skipForward() async {
    final target = _player.position + const Duration(seconds: 10);
    await _player.seek(target > state.duration ? state.duration : target);
  }

  Future<void> skipBackward() async {
    final target = _player.position - const Duration(seconds: 10);
    await _player.seek(target < Duration.zero ? Duration.zero : target);
  }

  Future<void> skipToNextChapter() async {
    final nextIdx = state.currentIndex + 1;
    if (nextIdx < params.chapters.length) {
      await seekToChapter(nextIdx);
    }
  }

  Future<void> skipToPreviousChapter() async {
    final prevIdx = state.currentIndex - 1;
    if (prevIdx >= 0) {
      await seekToChapter(prevIdx);
    }
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
    if (_disposed) return;
    _safeUpdate(state.copyWith(speed: speed));
  }

  @override
  void dispose() {
    _disposed = true;
    _playerStateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    super.dispose();
  }
}

final audioPlayerProvider = StateNotifierProvider.family<AudioPlayerNotifier, AudioPlayerState, AudioParams>(
  (ref, params) {
    final player = ref.watch(globalAudioPlayerProvider);
    return AudioPlayerNotifier(player, params);
  },
);