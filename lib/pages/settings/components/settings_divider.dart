import 'package:flutter/material.dart';

import '../../../configs/constants.dart';

class SettingsTitleDivider extends StatelessWidget {
  const SettingsTitleDivider({
    super.key,
    this.title,
    this.hideDivider = false,
  });

  final String? title;
  final bool hideDivider;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final indent = size.width * kDividerIndent;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: Column(
        children: [
          if (!hideDivider) ...[
            SizedBox(
              child: Divider(
                indent: indent,
                endIndent: indent,
              ),
            ),
          ],
          Align(
            alignment: const Alignment(-0.90, 0),
            child: title == null
                ? const SizedBox.shrink()
                : Text(title!,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }
}
