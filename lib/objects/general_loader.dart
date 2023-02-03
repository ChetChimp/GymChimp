import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gymchimp/main.dart';

void generalLoader(BuildContext context) {
  BuildContext dialogContext;
  showDialog(
      barrierDismissible: false,
      barrierColor: backgroundGrey,
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        Future.delayed(Duration(milliseconds: 750), () {
          Navigator.pop(dialogContext);
        });
        return Container(
            child: Center(
          child: SpinKitCircle(
            duration: const Duration(seconds: 1),
            color: accentColor,
            size: MediaQuery.of(context).size.height / 12,
          ),
        ));
      });
}
