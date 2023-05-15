import 'package:flutter/cupertino.dart';

class MyAlertDilaog {
  static void showMyDialog({
    required BuildContext context,
    required String title,
    required String content,
    required Function() tabNo,
    required Function() tabYes,
  }) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: tabNo,
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: tabYes,
            child: const Text('Yes'),
          )
        ],
      ),
    );
  }
}
