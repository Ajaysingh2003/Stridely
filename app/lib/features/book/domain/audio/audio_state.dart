// import 'package:equatable/equatable.dart';

// class AudioState extends Equatable {
//   final bool isPlaying;
//   final bool isLoading;
//   final bool isBuffering;

//   final Duration position;
//   final Duration duration;
//   final Duration bufferedPosition;

//   final double speed;

//   final String title;
//   final String? artwork;

//   const AudioState({
//     this.isPlaying = false,
//     this.isLoading = true,
//     this.isBuffering = false,
//     this.position = Duration.zero,
//     this.duration = Duration.zero,
//     this.bufferedPosition = Duration.zero,
//     this.speed = 1.0,
//     this.title = "",
//     this.artwork,
//   });

//   double get progress =>
//       duration.inMilliseconds == 0
//           ? 0
//           : position.inMilliseconds /
//               duration.inMilliseconds;

//   AudioState copyWith({
//     bool? isPlaying,
//     bool? isLoading,
//     bool? isBuffering,
//     Duration? position,
//     Duration? duration,
//     Duration? bufferedPosition,
//     double? speed,
//     String? title,
//     String? artwork,
//   }) {
//     return AudioState(
//       isPlaying: isPlaying ?? this.isPlaying,
//       isLoading: isLoading ?? this.isLoading,
//       isBuffering: isBuffering ?? this.isBuffering,
//       position: position ?? this.position,
//       duration: duration ?? this.duration,
//       bufferedPosition:
//           bufferedPosition ?? this.bufferedPosition,
//       speed: speed ?? this.speed,
//       title: title ?? this.title,
//       artwork: artwork ?? this.artwork,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         isPlaying,
//         isLoading,
//         isBuffering,
//         position,
//         duration,
//         bufferedPosition,
//         speed,
//         title,
//         artwork,
//       ];
// }