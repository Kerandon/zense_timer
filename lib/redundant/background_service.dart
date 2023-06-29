// import 'dart:async';
// import 'package:zense_timer/configs/constants.dart';
// import 'package:zense_timer/enums/session_state.dart';
// import 'package:zense_timer/state/app_state.dart';
// import 'package:zense_timer/state/audio_state.dart';
// import 'package:zense_timer/utils/methods/string_extensions.dart';
// import 'package:zense_timer/utils/methods/vibration_method.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_isolate/flutter_isolate.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:just_audio/just_audio.dart';
//
// AudioPlayer audioPlayerFirstBell = AudioPlayer();
// AudioPlayer audioPlayerSecondBell = AudioPlayer();
//
// @pragma('vm:entry-point')
// void playBellsIsolate(String data) async {
//   final bellTimes = data.parseNumbers();
//   final stringData = data.getPlusPrefixes();
//   final bell = stringData[0];
//   final bellOnEnd = stringData[1];
//   final vibrate = stringData[2];
//
//   await audioPlayerFirstBell.setAsset('assets/audio/bells/$bell.mp3');
//   await audioPlayerSecondBell.setAsset('assets/audio/bells/$bell.mp3');
//
//   for (var b in bellTimes) {
//     Timer(Duration(seconds: b), () async {
//       await audioPlayerFirstBell.seek(Duration.zero);
//       await audioPlayerFirstBell.play();
//       if (b == bellTimes.last) {
//         if (vibrate == 'true') {
//           await vibrateDeviceLong();
//         }
//       }
//     });
//
//     if (bellOnEnd == 'true') {
//       Timer(Duration(seconds: bellTimes.last + kEndBellGap), () async {
//         await audioPlayerSecondBell.seek(Duration.zero);
//         await audioPlayerSecondBell.play();
//       });
//     }
//   }
// }
//
// class BackgroundService extends ConsumerStatefulWidget {
//   const BackgroundService({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<BackgroundService> createState() => _WorkManagerExampleState();
// }
//
// class _WorkManagerExampleState extends ConsumerState<BackgroundService> {
//   bool _bellTaskIsRegistered = false;
//
//   Future<void> _stopIsolates() async {
//     await FlutterIsolate.killAll();
//   }
//
//   @override
//   Future<void> dispose() async {
//     await FlutterIsolate.killAll();
//     await audioPlayerFirstBell.dispose();
//     await audioPlayerSecondBell.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final appState = ref.watch(appProvider);
//     final audioState = ref.watch(audioProvider);
//
//     /// RESET
//     if (appState.lifecycleState == AppLifecycleState.resumed) {
//       _bellTaskIsRegistered = false;
//       _stopIsolates();
//     }
//
//     if (appState.lifecycleState == AppLifecycleState.paused ||
//         appState.lifecycleState == AppLifecycleState.inactive) {
//       if (appState.sessionState == SessionState.countdown ||
//           appState.sessionState == SessionState.inProgress) {
//         /// TASK IS NOT REGISTERED
//         if (!_bellTaskIsRegistered) {
//           _bellTaskIsRegistered = true;
//           List<String> isolateDataStringList = [];
//
//           final secondsElapsedMinusCountdown =
//               (appState.millisecondsElapsed ~/ 1000) - (appState.countdownTime);
//
//           /// CALCULATE BELL TIMES
//           for (var b in audioState.bellTimes) {
//             final adjustedTime = b - secondsElapsedMinusCountdown;
//             if (adjustedTime >= 0) {
//               isolateDataStringList.add('_$adjustedTime');
//             }
//           }
//
//           /// Add data about what bell to play
//           isolateDataStringList.add('+${audioState.bell.name}');
//
//           /// Add data if there will be a bell on end
//           isolateDataStringList.add('+${audioState.bellOnEnd.toString()}');
//
//           /// Add data if should vibrate
//           isolateDataStringList.add('+${appState.vibrate.toString()}');
//
//           /// Create data string
//           final isolateData = isolateDataStringList.join();
//
//           /// Spawn isolate
//           FlutterIsolate.spawn(playBellsIsolate, isolateData);
//         }
//       }
//     }
//     return const SizedBox.shrink();
//   }
// }
