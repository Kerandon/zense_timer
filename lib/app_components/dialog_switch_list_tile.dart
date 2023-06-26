import 'package:flutter/material.dart';
import '../configs/themes/app_colors.dart';

class DialogSwitchListTile extends StatelessWidget {
  const DialogSwitchListTile({
    required this.text,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String text;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.10,
      width: size.width,
      child: SwitchListTile(
        inactiveTrackColor: AppColors.disabledButton,
        inactiveThumbColor: AppColors.onDisabledButton,
        title: Text(
          text,
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
