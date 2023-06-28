import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    this.width = 0.06,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      delay: const Duration(seconds: 5),
      baseColor: Theme.of(context).colorScheme.primary,
      highlightColor: Theme.of(context).colorScheme.secondary,
      child: SizedBox(
        width: width * size.width,
        height: width * size.width,
        child: Image.asset(
          'assets/images/icon/app_icon_no_text.png',
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
