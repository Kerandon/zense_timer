import 'package:flutter/material.dart';

class MoreArrow extends StatelessWidget {
  const MoreArrow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0.8, -1),
      child: Icon(
        Icons.arrow_forward_ios_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
