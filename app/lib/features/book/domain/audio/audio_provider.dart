// import 'dart:async';

// import 'package:audio_service/audio_service.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod/legacy.dart';

// import 'audio_handler.dart';
// import 'audio_state.dart';

// final audioHandlerProvider =
//     Provider<AppAudioHandler>((ref) {
//   return AudioHandler as AppAudioHandler;
// });

// class AudioController extends StateNotifier<AudioState> {
//   final AppAudioHandler handler;

//   late final StreamSubscription _playbackSub;
//   late final StreamSubscription _durationSub;
//   late final StreamSubscription _mediaSub;

//   AudioController(this.handler)
//       : super(const AudioState()) {
//     _listen();
//   }

//   void _listen() {
//     _playbackSub =
//         handler.playbackState.listen((playback) {
//       state = state.copyWith(
//         isPlaying: playback.playing,
//         isLoading: playback.processingState ==
//             AudioProcessingState.loading,
//         isBuffering:
//             playback.processingState ==
//                 AudioProcessingState.buffering,
//         position: playback.updatePosition,
//         bufferedPosition:
//             playback.bufferedPosition,
//         speed: playback.speed,
//       );
//     });

//     _durationSub =
//         handler.player.durationStream.listen((d) {
//       if (d == null) return;

//       state = state.copyWith(
//         duration: d,
//       );
//     });

//     _mediaSub = handler.mediaItem.listen((item) {
//       if (item == null) return;

//       state = state.copyWith(
//         title: item.title,
//         artwork: item.artUri?.toString(),
//       );
//     });
//   }

//   Future<void> playPause() async {
//     if (handler.player.playing) {
//       await handler.pause();
//     } else {
//       await handler.play();
//     }
//   }

//   Future<void> seek(Duration position) =>
//       handler.seek(position);

//   Future<void> skipForward() =>
//       handler.seek(
//         handler.player.position +
//             const Duration(seconds: 10),
//       );

//   Future<void> skipBackward() =>
//       handler.seek(
//         handler.player.position -
//             const Duration(seconds: 10),
//       );

//   Future<void> setSpeed(double speed) =>
//       handler.player.setSpeed(speed);

//   Future<void> load({
//     required String id,
//     required String title,
//     required String url,
//     String? artwork,
//   }) =>
//       handler.loadBook(
//         id: id,
//         title: title,
//         url: url,
//         artwork: artwork,
//       );

//   @override
//   void dispose() {
//     _playbackSub.cancel();
//     _durationSub.cancel();
//     _mediaSub.cancel();
//     super.dispose();
//   }
// }

// final audioControllerProvider =
//     StateNotifierProvider<AudioController, AudioState>(
//   (ref) {
//     return AudioController(
//       ref.watch(audioHandlerProvider),
//     );
//   },
// );