import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/openingScreens/home_page.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:gymchimp/openingScreens/new_workout.dart';
import 'package:gymchimp/openingScreens/sign_up_page.dart';
import 'package:gymchimp/openingScreens/start_page.dart';
import '../firebase_options.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  State<PlanPage> createState() => _PlanPage();
}

void newWorkout(BuildContext ctx) {
  Navigator.of(ctx).push(MaterialPageRoute(builder: (context) => NewWorkout()));
}

class _PlanPage extends State<PlanPage> {
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            builder: (_) => MaterialApp(
                  title: 'Welcome to Flutter',
                  home: Scaffold(
                    appBar: MyAppBar(context),
                    body: const Center(
                      child: Text('Welcome to Plan Page'),
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        newWorkout(_);
                      },
                      child: Icon(Icons.add),
                    ),
                  ),
                ));
        // WidgetBuilder builder;
        // builder = (BuildContext _) =>
      },
    );
  }
}

class MyAppBar extends AppBar {
  //@override
  //Widget build(BuildContext context) {
  MyAppBar(BuildContext ctx)
      : super(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                if (Navigator.of(ctx).canPop()) {
                  Navigator.of(ctx).pop();
                } else {
                  Navigator.of(ctx, rootNavigator: true).pop();
                }
              }),
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
                color: Colors.black,
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {}),
          ],
        );
  // }
}
