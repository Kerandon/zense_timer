import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../enums/bell.dart';
import '../../../../configs/constants.dart';
import '../../../../enums/bell_stage.dart';
import 'bells_checkbox_tile.dart';

class BellsSoundsPage extends ConsumerWidget {
  const BellsSoundsPage({Key? key, required this.bellStage}) : super(key: key);

  final BellStage bellStage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    String title = '';
    switch (bellStage) {
      case BellStage.start:
        title = 'Start Bell';
        break;
      case BellStage.interval:
        title = 'Interval Bell';
        break;
      case BellStage.end:
        title = 'End Bell';
        break;
    }

    final bells = Bell.values.toList();

    bells.sort((a, b) {
      if (a.name == kNone) {
        return -1; // 'none' should be before any other string
      } else if (b.name == kNone) {
        return 1; // 'none' should be before any other string
      } else {
        return a
            .toText()
            .compareTo(b.toText()); // normal alphabetical comparison
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
              childCount: bells.length,
              (context, index) {
                return BellsCheckBoxTile(
                  bell: bells[index],
                  bellStage: bellStage,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
