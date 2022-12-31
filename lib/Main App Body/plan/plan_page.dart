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
import 'package:gymchimp/main.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import '../app_bar.dart';
import '../home_page.dart';
import '../start_page.dart';
import '../workout/workout_page.dart';
import 'new_workout.dart';
import '../workout/workout.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  State<PlanPage> createState() => _PlanPage();
}

List<Widget> workoutList = [];
String workoutName = "";
final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
int counter = 0;
Workout selectedWorkout = Workout("");

void newWorkout(BuildContext ctx, int index) {
  Navigator.of(ctx).push(MaterialPageRoute(
      builder: (context) =>
          NewWorkout(workoutName: workoutName, index: index)));
}

class _PlanPage extends State<PlanPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> pushWorkoutToDatabase(BuildContext ctx) async {
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
    currentUser.addWorkout(Workout(workoutName));
    listKey.currentState
        ?.insertItem(0, duration: const Duration(milliseconds: 200));
  }

  Widget slideIt(BuildContext context, int index, animation) {
    return Container(
      child: Card(
        child: Row(
          children: [
            Spacer(),
            Text(currentUser.userWorkouts[index].getName()),
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  newWorkout(context, index);
                },
                child: Text("Edit")),
            Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  currentWorkout = currentUser.userWorkouts[index];
                });
              },
              icon: Icon(Icons.check_box_outline_blank),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            builder: (_) => MaterialApp(
                  title: 'Welcome to Flutter',
                  home: Scaffold(
                    appBar: MyAppBar(context, true),
                    body: Container(
                        child: Column(
                      children: [
                        Container(
                            height: size.height - (size.height / 3),
                            child: AnimatedList(
                              key: listKey,
                              initialItemCount:
                                  currentUser.getUserWorkouts.length,
                              itemBuilder: (context, index, animation) {
                                return slideIt(
                                    context, index, animation); // Refer step 3
                              },
                            )),
                        IconButton(
                          iconSize: 30,
                          icon: Icon(color: Colors.red, Icons.delete_sharp),
                          onPressed: () {},
                        ),
                      ],
                    )),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () async {
                        await pushWorkoutToDatabase(context);
                      },
                      child: Icon(Icons.add),
                    ),
                  ),
                ));
      },
    );
  }
}
