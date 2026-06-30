// import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';

// class AppAudioHandler extends BaseAudioHandler
//     with QueueHandler, SeekHandler {
//   final AudioPlayer player = AudioPlayer();

//   AppAudioHandler() {
//     _listenPlayback();
//   }

//   void _listenPlayback() {
//     player.playbackEventStream.listen((event) {
//       playbackState.add(
//         PlaybackState(
//           controls: [
//             MediaControl.skipToPrevious,
//             if (player.playing)
//               MediaControl.pause
//             else
//               MediaControl.play,
//             MediaControl.stop,
//             MediaControl.skipToNext,
//           ],
//           systemActions: const {
//             MediaAction.seek,
//             MediaAction.seekForward,
//             MediaAction.seekBackward,
//           },
//           androidCompactActionIndices: const [0, 1, 3],
//           processingState: _processingState(player.processingState),
//           playing: player.playing,
//           updatePosition: player.position,
//           bufferedPosition: player.bufferedPosition,
//           speed: player.speed,
//         ),
//       );
//     });
//   }

//   AudioProcessingState _processingState(
//       ProcessingState state) {
//     switch (state) {
//       case ProcessingState.idle:
//         return AudioProcessingState.idle;

//       case ProcessingState.loading:
//         return AudioProcessingState.loading;

//       case ProcessingState.buffering:
//         return AudioProcessingState.buffering;

//       case ProcessingState.ready:
//         return AudioProcessingState.ready;

//       case ProcessingState.completed:
//         return AudioProcessingState.completed;
//     }
//   }

//   Future<void> loadBook({
//     required String id,
//     required String title,
//     required String url,
//     String? artwork,
//   }) async {
//     mediaItem.add(
//       MediaItem(
//         id: id,
//         title: title,
//         album: "Book Summary",
//         artUri: artwork == null
//             ? null
//             : Uri.parse(artwork),
//       ),
//     );

//     await player.setAudioSource(
//       AudioSource.uri(Uri.parse(url)),
//     );
//   }

//   @override
//   Future<void> play() => player.play();

//   @override
//   Future<void> pause() => player.pause();

//   @override
//   Future<void> stop() async {
//     await player.stop();
//     return super.stop();
//   }

//   @override
//   Future<void> seek(Duration position) =>
//       player.seek(position);

//   @override
//   Future<void> skipToNext() async {}

//   @override
//   Future<void> skipToPrevious() async {}
// }