import 'package:flutter/material.dart';

deleteConfirmPopup(String text, BuildContext context, Function onPressed) {
  showDialog<String>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
        title: Text(text),
        actions: <Widget>[
          TextButton(
            child: const Text('No, go back'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Yes, delete it',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onPressed();
            },
          )
        ],
      );
    },
  );
}
