import 'package:flutter/material.dart';
import '../../../configs/constants.dart';
import 'headline_last_mediation.dart';

class LastMeditationTile extends StatefulWidget {
  const LastMeditationTile({Key? key}) : super(key: key);

  @override
  State<LastMeditationTile> createState() => _LastMeditationTileState();
}

class _LastMeditationTileState extends State<LastMeditationTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(kBorderRadiusBig)),
      child: const Column(
        children: [
          Expanded(
            flex: 2,
            child: Icon(
              Icons.query_stats,
              size: kDashboardIconSize,
            ),
          ),
          Expanded(flex: 2, child: HeadlineLastMeditation()),

          Expanded(child: SizedBox())
          // MoreArrow(),
        ],
      ),
    );
  }
}
