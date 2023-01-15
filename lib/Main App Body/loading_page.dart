import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gymchimp/Main%20App%20Body/start_page.dart';
import 'package:gymchimp/main.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    addUserInfo();
    readWorkoutsFirebase();
    checkLoading();
  }

  void checkLoading() {
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (isLoading) {
        // Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StartPage()),
        );
        t.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundGrey,
        body: Center(
          child: SpinKitPouringHourGlassRefined(
            duration: const Duration(seconds: 1),
            color: accentColor,
            size: MediaQuery.of(context).size.height / 12,
          ),
        ));
  }
}
