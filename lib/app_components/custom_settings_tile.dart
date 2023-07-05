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
    final size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: size.width * 0.80,
        maxWidth: size.width,
        minHeight: size.height * 0.05,
        maxHeight: size.height * 0.15,
      ),
      child: ListTile(
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
      ),
    );
  }
}
