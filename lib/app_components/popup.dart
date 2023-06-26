import 'package:flutter/material.dart';

Future<void> showPopup(
    {required BuildContext context,
    required String text,
    bool barrierDismissible = true,
    final delay = 0}) async {
  Future.delayed(Duration(milliseconds: delay), () {
    if (context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showDialog(
            useRootNavigator: false,
            barrierColor: Colors.transparent,
            barrierDismissible: barrierDismissible,
            context: context,
            builder: (context) => PopUp(text));
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (context.mounted) {
            Navigator.of(context).pop('dialog');
          }
        });
      });
    }
  });
}

class PopUp extends StatelessWidget {
  const PopUp(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size.height * 0.15,
          ),
          child: AlertDialog(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          )),
    );
  }
}
