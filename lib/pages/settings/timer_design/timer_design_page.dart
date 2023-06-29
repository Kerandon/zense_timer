import 'package:zense_timer/app_components/app_icon.dart';
import 'package:zense_timer/app_components/custom_animated_grid_box.dart';
import 'package:zense_timer/pages/home_page/center_timer/custom_clocks/custom_timer_background.dart';
import 'package:zense_timer/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../app_components/custom_switch_list_tile.dart';
import '../../../configs/constants.dart';
import '../../../enums/clock_design.dart';
import '../../home_page/center_timer/custom_clocks/custom_semi.dart';
import '../../home_page/center_timer/custom_clocks/custom_timer_clock.dart';
import '../../home_page/center_timer/custom_clocks/custom_timer_dash.dart';
import '../../home_page/center_timer/custom_clocks/custom_timer_dots.dart';
import '../../home_page/center_timer/custom_clocks/custom_timer_line.dart';
import '../../home_page/center_timer/custom_clocks/custom_timer_solid.dart';

class TimerFacePage extends ConsumerStatefulWidget {
  const TimerFacePage({Key? key}) : super(key: key);

  @override
  ConsumerState<TimerFacePage> createState() => _TimerDesignPageState();
}

class _TimerDesignPageState extends ConsumerState<TimerFacePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controllerPercent;
  double _percent = 0.0;

  @override
  void initState() {
    _controllerPercent = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    )..addListener(() {
        _percent = _controllerPercent.value;
        setState(() {});
      });
    _controllerPercent.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controllerPercent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color shimmerHighlightColor = Theme.of(context).colorScheme.secondary;

    if (!state.showTimer) {
      primaryColor = Colors.transparent;
      shimmerHighlightColor = Colors.transparent;
    }
    if (state.showTimer) {
      _controllerPercent.repeat();
    }

    const innerPadding = 0.08;

    if (state.reverseTimer) {
      _percent = (1.0 - _percent);
    }

    final outerPadding = size.width * kPageIndentation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Face'),
      ),
      body: Padding(
        padding:
            EdgeInsets.fromLTRB(outerPadding, outerPadding, outerPadding, 0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: CustomSwitchListTile(
                  topPadding: true,
                  title: 'Show progress bar',
                  icon: FontAwesomeIcons.clock,
                  value: state.showTimer,
                  onChanged: (value) => notifier.showTimerDesign(value)),
            ),
            SliverToBoxAdapter(
              child: CustomSwitchListTile(
                title: 'Reverse progress bar',
                icon: FontAwesomeIcons.clockRotateLeft,
                value: state.reverseTimer,
                onChanged: (value) => notifier.setReverseTimer(value),
              ),
            ),
            SliverToBoxAdapter(
              child: CustomSwitchListTile(
                  bottomPadding: true,
                  title: 'Show clock',
                  icon: Icons.onetwothree_outlined,
                  value: state.showClock,
                  onChanged: (value) => notifier.setShowClock(value)),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                crossAxisCount: 2,
              ),
              delegate: SliverChildBuilderDelegate(
                childCount: TimerDesign.values.length,
                (context, index) {
                  final design = TimerDesign.values.elementAt(index);

                  CustomPainter? customPainter;

                  switch (design) {
                    case TimerDesign.circle:
                      customPainter = CustomTimerSolid(
                        percentage: _percent,
                      );
                      break;
                    case TimerDesign.dash:
                      customPainter = CustomTimerDash(
                        percentage: _percent,
                      );
                      break;
                    case TimerDesign.dots:
                      customPainter = CustomTimerDots(
                        percentage: _percent,
                      );
                      break;
                    case TimerDesign.clock:
                      customPainter = CustomTimeClock(
                        percentage: _percent,
                      );
                      break;
                    case TimerDesign.semi:
                      customPainter = CustomSemi(
                        percentage: _percent,
                      );
                      break;
                    case TimerDesign.line:
                      customPainter = CustomTimerLine(percentage: 0.50);
                      break;
                  }

                  return CustomAnimatedGridBox(
                    //labelText: design.name,
                    onPressed: state.showTimer
                        ? () {
                            notifier.setTimerDesign(design);
                          }
                        : null,
                    isSelected: design == state.timerDesign && state.showTimer,
                    contents: Stack(
                      children: [
                        SizedBox.expand(
                          child: Padding(
                            padding: EdgeInsets.all(size.width * innerPadding),
                            child: CustomPaint(
                              painter: CustomTimerBackground(
                                timerDesign: design,
                                clockBackground: Theme.of(context)
                                    .colorScheme
                                    .shadow
                                    .withOpacity(kBackgroundTimerOpacity),
                                clockLongTick:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width,
                          height: size.height,
                          child: Shimmer.fromColors(
                            baseColor: primaryColor,
                            highlightColor: shimmerHighlightColor,
                            delay: const Duration(seconds: kShimmerDelay),
                            child: Padding(
                              padding:
                                  EdgeInsets.all(size.width * innerPadding),
                              child: CustomPaint(
                                painter: customPainter,
                              ),
                            ),
                          ),
                        ),
                        if (state.showClock) ...[
                          const Center(
                              child: Icon(
                            Icons.onetwothree_outlined,
                            size: 35,
                          ))
                        ],
                        if (!state.showClock) ...[
                          const Center(child: AppIcon())
                        ],
                      ],
                    ),
                    labelAlignment: Alignment.center,
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: size.height * kEndPagePadding,
              ),
            )
          ],
        ),
      ),
    );
  }
}
