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
import 'package:gymchimp/login-signup/questionnairePages/askName_page.dart';
import 'package:gymchimp/main.dart';
import '../../app_bar.dart';
import '../../home_page.dart';
import '../../start_page.dart';
import '../../workout/workout_page.dart';
import '../../../Firebase/custom_firebase_functions.dart';
import '../../../objects/workout.dart';
import 'dart:async';

import '../new workout page/new_workout_page.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PlanPage extends StatefulWidget {
  // PlanPage(this.stream);
  // final Stream<int> stream;

  @override
  State<PlanPage> createState() => _PlanPage();
}

Function planPageSetState = () {};

String workoutName = "";
//final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
int counter = 0;
Workout selectedWorkout = Workout("");

class _PlanPage extends State<PlanPage> {
  @override
  void initState() {
    planPageSetState = publicStateSetter;
    super.initState();
  }

  void newWorkout(BuildContext ctx, Workout newWorkoutObject) {
    Navigator.of(ctx).push(MaterialPageRoute(
        builder: (context) => NewWorkoutPage(
              workout: newWorkoutObject,
            )));
  }

  void publicStateSetter(Function func) {
    setState(() {
      func();
    });
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  backgroundColor: backgroundGrey,
                  appBar: MyAppBar(context, true, "plan_page"),
                  body: ReorderableListView(
                      proxyDecorator: proxyDecorator,
                      //key: listKey,
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
                          //margin: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.transparent
                              // gradient: LinearGradient(colors: primaryGradient),
                              ),
                          child: TextButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.only(top: 35, bottom: 35),
                              backgroundColor: foregroundGrey,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                            ),
                            onPressed: () {
                              newWorkout(
                                  context, currentUser.getUserWorkouts[index]);
                            },
                            child: Row(
                              children: [
                                Spacer(),
                                Container(
                                  child: Text(
                                    currentUser.userWorkouts[index].getName(),
                                    style: TextStyle(
                                        fontSize: 25, color: accentColor),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        );
                      })),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: foregroundGrey,
                    onPressed: () async {
                      Workout newWorkoutObject = Workout(workoutName);
                      await addWorkoutToFirebase(context, newWorkoutObject)
                          .then((value) {});
                      setState(() {
                        currentUser.addWorkout(newWorkoutObject);
                      });
                      newWorkout(context, newWorkoutObject);
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ));
      },
    );
  }
}
