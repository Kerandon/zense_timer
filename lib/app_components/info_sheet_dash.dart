import 'package:zense_timer/configs/constants.dart';
import 'package:flutter/material.dart';

class InfoSheetDash extends StatelessWidget {
  const InfoSheetDash({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(top: size.height * 0.02, bottom: size.height * 0.03),
      child: Center(
        child: Container(
          width: size.width * 0.15,
          height: 5,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.shadow,
              borderRadius: BorderRadius.circular(kBorderRadiusBig)),
        ),
      ),
    );
  }
}
