import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import '../../../configs/constants.dart';
import 'guide_text_box.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthPadding = size.width * kSettingsHorizontalPageIndent / 2;
    final heightPadding = size.height * 0.02;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation Guide'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            widthPadding,
            heightPadding,
            widthPadding,
            heightPadding,
          ),
          child: Column(
            children: [
              Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.primary,
                  highlightColor: Theme.of(context).colorScheme.secondary,
                  delay: const Duration(seconds: 6),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.10),
                    child: Container(
                      height: size.height * 0.30,
                      width: size.width * 0.90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kBorderRadiusBig),
                        image: const DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: AssetImage('assets/images/solo.png'),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(begin: 0, duration: 1.seconds)
                        .scaleXY(begin: 0.96, duration: 1.seconds)
                        .slideY(begin: -0.03, duration: 1.seconds),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                child: const Column(
                  children: [
                    GuideTextBox(
                        text: 'Step 1', isHeading: true, delayIndex: 1),
                    GuideTextBox(
                        text: 'Place your attention on your breath',
                        delayIndex: 2),
                    GuideTextBox(
                        text: 'Step 2', isHeading: true, delayIndex: 3),
                    GuideTextBox(
                        text:
                            'If you find your mind has wandered, gently return your attention to your breath',
                        delayIndex: 4),
                    GuideTextBox(
                      text: 'Step 3',
                      isHeading: true,
                      delayIndex: 5,
                    ),
                    GuideTextBox(
                      text: 'Repeat',
                      delayIndex: 6,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
