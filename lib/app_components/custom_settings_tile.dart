import 'package:flutter/material.dart';

class CustomSettingsTile extends StatelessWidget {
  const CustomSettingsTile({
    required this.title,
    required this.onPressed,
    this.subTitle,
    required this.icon,
    super.key,
  });

  final String title;
  final String? subTitle;
  final Icon? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: subTitle != null
          ? Text(
              subTitle!,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            )
          : null,
      leading: Icon(icon!.icon),
      title: Text(title),
      onTap: onPressed,
      trailing: const Icon(
        Icons.arrow_forward_ios_outlined,
      ),
    );
  }
}
