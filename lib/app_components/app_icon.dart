import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    this.width,
  });

  final double? width;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.primary,
      highlightColor: Theme.of(context).colorScheme.secondary,
      child: SizedBox(
        width: width ?? size.width * 0.06,
        height: width ?? size.width * 0.06,
        child: Image.asset(
          'assets/images/icon/app_icon_no_text.png',
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
