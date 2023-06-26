import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../configs/constants.dart';
import '../../../data/bell_times.dart';
import 'countdown_checklist.dart';

class CountdownPage extends ConsumerWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warm-up Countdown'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: size.height * kListTopPadding,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: countdownTimes.length,
              (context, index) {
                return CountdownChecklist(
                  countdownTime: countdownTimes[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
