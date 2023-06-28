import 'package:zense_timer/configs/constants.dart';
import 'package:zense_timer/enums/bell.dart';
import 'package:zense_timer/enums/bell_stage.dart';
import 'package:zense_timer/models/bell_random.dart';
import 'package:zense_timer/state/app_state.dart';
import 'package:zense_timer/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../app_components/custom_button.dart';
import '../../../../app_components/info_sheet_dash.dart';
import '../../../../data/bell_times.dart';
import '../../../../enums/interval_bell_type.dart';
import '../../../../state/audio_state.dart';
import 'bell_volume_slider.dart';
import 'bells_sounds_page.dart';

class BellInfoSheet extends ConsumerStatefulWidget {
  const BellInfoSheet({
    super.key,
  });

  @override
  ConsumerState<BellInfoSheet> createState() => _BellInfoSheetState();
}

class _BellInfoSheetState extends ConsumerState<BellInfoSheet> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(appProvider);
    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);

    List<int> fixedTimes = [];
    List<BellRandom> randomTimes = [];

    if (!appState.openSession) {
      fixedTimes = possibleBellTimes
          .takeWhile((value) => value < appState.time)
          .toList();

      randomTimes =
          randomBells.takeWhile((value) => value.max <= appState.time).toList();
    } else {
      fixedTimes = possibleBellTimes.toList();
      randomTimes = randomBells.toList();
    }

    final padding = size.width * 0.05;
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, padding * 2),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InfoSheetDash(),
            if (audioState.bellIntervalSound.name != kNone ||
                audioState.bellOnEndSound.name != kNone) ...[
              Padding(
                padding: EdgeInsets.all(size.height * 0.03),
                child: const BellVolumeSlider(),
              ),
              const Divider(),
            ],
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BellsSoundsPage(
                      bellStage: BellStage.start,
                    ),
                  ),
                );
              },
              title: const Text('Start bell'),
              subtitle: Text(audioState.bellOnStartSound.toText(),
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: audioState.bellOnStartSound.name == kNone
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.primary,
                      )),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BellsSoundsPage(
                      bellStage: BellStage.interval,
                    ),
                  ),
                );
              },
              title: const Text('Interval bell'),
              subtitle: Text(
                audioState.bellIntervalSound.toText(),
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: audioState.bellIntervalSound.name == kNone
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.primary,
                    ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
            if (audioState.bellIntervalSound.name != kNone) ...[
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.01,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                          minButtonWidth: 0.35,
                          isSelected: audioState.bellType == BellType.fixed,
                          onPressed: () =>
                              audioNotifier.setIntervalBellType(BellType.fixed),
                          text: 'Fixed bells',
                        ),
                        CustomButton(
                          minButtonWidth: 0.35,
                          isSelected: audioState.bellType == BellType.random,
                          onPressed: () => audioNotifier
                              .setIntervalBellType(BellType.random),
                          text: 'Random bells',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Center(
                      child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 2,
                          runSpacing: 2,
                          children:

                              /// FIXED BELLS
                              audioState.bellType == BellType.fixed
                                  ? fixedTimes.map((time) {
                                      bool isSelected = false;

                                      /// Check if the child is the same as the selected bell.
                                      if (time == audioState.bellFixedTime) {
                                        isSelected = true;
                                      }

                                      /// FOR FIXED TIME ONLY, NEED TO TAKE INTO ACCOUNT IF USER REDUCES THE TOTAL FIXED TIME
                                      if (!appState.openSession) {
                                        /// If [time] is greater than currently selected [bellFixedTime] then
                                        /// the selected bell will be changed to the last time in range
                                        if (audioState.bellFixedTime >=
                                            appState.time) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                                  (timeStamp) {
                                            audioNotifier
                                                .setBellFixed(fixedTimes.last);
                                          });
                                        }
                                      }

                                      return CustomButton(
                                          isSelected: isSelected,
                                          minButtonWidth: 0.26,
                                          text: time.formatFromMilliseconds(),
                                          onPressed: () {
                                            audioNotifier.setBellFixed(time);
                                          });
                                    }).toList()

                                  /// RANDOM BELLS
                                  : randomTimes.map((e) {
                                      bool isSelected =
                                          audioState.bellRandom.index ==
                                              e.index;

                                      /// If a shorter time is selected, this will set
                                      /// the selected bell to the biggest max range that
                                      /// does not exceed the time.
                                      if (!appState.openSession) {
                                        if (audioState.bellRandom.max >
                                            randomTimes.last.max) {
                                          if (e.index ==
                                              randomTimes.last.index) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                    (timeStamp) {
                                              audioNotifier.setRandomRange(e);
                                            });
                                          }
                                        }
                                      }

                                      return CustomButton(
                                          isSelected: isSelected,
                                          minButtonWidth: 0.26,
                                          text:
                                              '${e.min.toInt().formatFromMilliseconds()} '
                                              '- ${e.max.toInt().formatFromMilliseconds()}',
                                          onPressed: () async =>
                                              audioNotifier.setRandomRange(e));
                                    }).toList()))
                ],
              ),
              if (audioState.bellIntervalSound.name != kNone) ...[
                const Divider(),
              ],
            ],
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BellsSoundsPage(
                      bellStage: BellStage.end,
                    ),
                  ),
                );
              },
              title: const Text('End bell'),
              subtitle: Text(audioState.bellOnEndSound.toText(),
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: audioState.bellOnEndSound.name == kNone
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.primary,
                      )),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}
