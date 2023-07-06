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
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: size.width * 0.60,
          maxWidth: size.width,
          minHeight: size.height * 0.05,
          maxHeight: size.height * 0.15,
        ),
        child: ListTile(
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: AppColors.disabledButton,
                      ),
                )
              : null,
          leading: icon == null
              ? null
              : ConstrainedBox(
                  constraints: buildBoxConstraints(size),
                  child: Icon(
                    icon,
                  ),
                ),
          title: Text(title),
          trailing: ConstrainedBox(
            constraints: buildBoxConstraints(size),
            child: Switch(
              inactiveThumbColor:
                  Theme.of(context).colorScheme.onInverseSurface,
              inactiveTrackColor: AppColors.disabledButton,
              value: value,
              onChanged: disable ? null : onChanged,
            ),
          ),
        ),
      ),
    );
  }

  BoxConstraints buildBoxConstraints(Size size) {
    return BoxConstraints(
            minWidth: size.width * 0.05,
            maxWidth: size.width * 0.20,
            minHeight: size.height * 0.05,
            maxHeight: size.height * 0.15,
          );
  }
}
