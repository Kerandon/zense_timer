import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app_components/custom_button.dart';
import '../../../configs/constants.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;
import '../../../state/app_state.dart';

class DNDAccessDialog extends ConsumerWidget {
  const DNDAccessDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(appProvider.notifier);
    _checkIfAccessTurnedOn(context);
    return AlertDialog(
      title: Column(
        children: [
          Text(
            kAllowPermissionTitle1,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            kAllowPermissionTitle2,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.normal),
          ),
        ],
      ),
      content: const Text(kAllowPermissionSubtitle),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        CustomButton(
            setToBackgroundColor: true,
            text: 'OK',
            onPressed: () async {
              openAppSettings();
              final status = await permissions
                  .Permission.accessNotificationPolicy
                  .request();
              if (status.isGranted) {
                if (context.mounted) {
                  await Navigator.maybePop(context);
                  notifier.setMuteDevice(true);
                }
              } else {
                notifier.setMuteDevice(false);
              }
            }),
        CustomButton(
            setToBackgroundColor: true,
            text: 'Cancel',
            onPressed: () async {
              await Navigator.maybePop(context);
              notifier.setMuteDevice(false);
            })
      ],
    );
  }

  Future<void> _checkIfAccessTurnedOn(BuildContext context) async {
    if (await permissions.Permission.accessNotificationPolicy.isGranted ==
        true) {
      if (context.mounted) {
        await Navigator.maybePop(context);
      }
    }
  }
}
