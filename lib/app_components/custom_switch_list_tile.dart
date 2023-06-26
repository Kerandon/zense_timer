import 'package:zense_timer/configs/themes/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSwitchListTile extends StatelessWidget {
  const CustomSwitchListTile({
    super.key,
    required this.title,
    this.icon,
    required this.value,
    required this.onChanged,
    this.insets,
    this.disable = false,
    this.topPadding = false,
    this.bottomPadding = false,
    this.subtitle,
  });

  final String title;
  final IconData? icon;
  final bool value;
  final Function(bool) onChanged;
  final EdgeInsets? insets;
  final bool disable;
  final bool topPadding, bottomPadding;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding ? size.height * 0.02 : 0,
        bottom: bottomPadding ? size.height * 0.02 : 0,
      ),
      child: SwitchListTile(
        inactiveTrackColor: AppColors.disabledButton,
        inactiveThumbColor: AppColors.onDisabledButton,
        onChanged: disable ? null : onChanged,
        value: value,
        title: Text(
          title,
        ),
        secondary: Icon(icon),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: AppColors.disabledButton,
                    ),
              )
            : null,
      ),
    );
  }
}
