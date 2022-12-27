import 'dart:collection';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import '../../Sign up/sign_up_page.dart';
import '../app_bar.dart';
import 'new_workout.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  State<PlanPage> createState() => _PlanPage();
}

String workoutName = "";
void newWorkout(BuildContext ctx) {
  Navigator.of(ctx).push(MaterialPageRoute(
      builder: (context) => NewWorkout(
            workoutName: workoutName,
          )));
}

void pushWorkoutToDatabase(BuildContext ctx) async {
  QuerySnapshot querySnapshot = await firestore
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('workouts')
      .get();

  List list = querySnapshot.docs;
  List list2 = [];
  list.forEach((element) {
    list2.add(element.id);
  });
  print(list2);

  int i = 0;
  while (list2.contains("Untitled Workout [" + i.toString() + "]")) {
    i++;
  }
  workoutName = "Untitled Workout [" + i.toString() + "]";

  await firestore
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('workouts')
      .doc(workoutName)
      .set({'name': workoutName});

  newWorkout(ctx);
}

class _PlanPage extends State<PlanPage> {
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            builder: (_) => MaterialApp(
                  title: 'Welcome to Flutter',
                  home: Scaffold(
                    appBar: MyAppBar(context, true),
                    body: const Center(
                      child: Text('Welcome to Plan Page'),
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        pushWorkoutToDatabase(context);
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
