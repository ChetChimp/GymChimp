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
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:google_fonts/google_fonts.dart';
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
  // PlanPage(this.stream);
  // final Stream<int> stream;

  @override
  State<PlanPage> createState() => _PlanPage();
}

Function nameUpdater = () {};

//List<Widget> workoutList = [];
String workoutName = "";
final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
int counter = 0;
Workout selectedWorkout = Workout("");

class _PlanPage extends State<PlanPage> {
  @override
  void initState() {
    nameUpdater = updateNameState;
    super.initState();
  }

  void newWorkout(BuildContext ctx, int index) {
    Navigator.of(ctx).push(MaterialPageRoute(
        builder: (context) => NewWorkoutPage(
              workoutName: workoutName,
              index: index,
              callback: mySetState,
            )));
  }

  void updateNameState(String input) {
    setState(() {
      currentUser.userWorkouts[workoutIndex].name = input;
    });
  }

  void mySetState(int index) {
    setState(() {
      currentUser.userWorkouts.removeAt(index);
    });
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
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  appBar: MyAppBar(context, true, "plan_page"),
                  body: ReorderableListView(
                      proxyDecorator: proxyDecorator,
                      key: listKey,
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          if (newIndex >= currentUser.getNumWorkouts) {
                            newIndex -= 1;
                          }
                          currentUser.moveWorkout(oldIndex, newIndex);
                        });
                      },
                      children: List.generate(currentUser.userWorkouts.length,
                          (index) {
                        return Container(
                          key: Key('$index'),
                          margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.transparent
                              // gradient: LinearGradient(colors: primaryGradient),
                              ),
                          child: TextButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                            ),
                            onPressed: () {
                              newWorkout(context, index);
                            },
                            child: Row(
                              children: [
                                Spacer(),
                                Container(
                                  child: Text(
                                    currentUser.userWorkouts[index].getName(),
                                    style: TextStyle(
                                        fontSize: 20, color: accentColor),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        );
                      })),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      await pushWorkoutToDatabase(context);

                      setState(() {
                        currentUser.addWorkout(Workout(workoutName));
                      });

                      newWorkout(context, currentUser.getNumWorkouts - 1);
                    },
                    child: Icon(Icons.add),
                  ),
                ));
      },
    );
  }
}
