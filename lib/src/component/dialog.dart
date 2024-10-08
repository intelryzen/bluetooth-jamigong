import 'package:flutter/material.dart';

alreadyConnectedDialog(BuildContext context, Function() onPressed) async {
  return await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('이미 연동된 기기가 있습니다.'),
        content: const Text(
          '연동을 해제할까요?',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text(
              '연동해제',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              onPressed.call();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text(
              '아니요',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
