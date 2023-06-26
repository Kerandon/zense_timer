import 'package:zense_timer/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app_components/custom_button.dart';
import '../../../app_components/loading_helper.dart';
import '../../../state/database_service.dart';

class ResetDialog extends StatefulWidget {
  const ResetDialog({
    super.key,
  });

  @override
  State<ResetDialog> createState() => _ResetDialogState();
}

class _ResetDialogState extends State<ResetDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Reset all app settings & dashboard data?\n',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        CustomButton(
          setToBackgroundColor: true,
          text: 'Yes',
          onPressed: () async {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => LoadingHelper(
                      future: Future.wait([
                        DatabaseServiceAppData().deleteAll(),
                      ]),
                      onComplete: () async {
                        SharedPreferences.getInstance().then((prefs) async {
                          await prefs.clear();
                        });
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const ZenseApp()),
                              (route) => false);
                        });
                      },
                    ));
          },
        ),
        CustomButton(
          setToBackgroundColor: true,
          text: 'Cancel',
          onPressed: () async {
            await Navigator.of(context).maybePop();
          },
        ),
      ],
    );
  }
}
