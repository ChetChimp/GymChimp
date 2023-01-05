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

//List<Widget> workoutList = [];
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

  // Widget slideIt(BuildContext context, int index) {
  //   return Container(
  //     margin: EdgeInsets.only(top: 10, left: 15, right: 15),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(15.0),
  //       gradient: LinearGradient(colors: primary),
  //     ),
  //     child: ElevatedButton(
  //       style: OutlinedButton.styleFrom(
  //         backgroundColor: Colors.transparent,
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(15))),
  //       ),
  //       onPressed: () {
  //         newWorkout(context, index);
  //       },
  //       child: Row(
  //         children: [
  //           Spacer(),
  //           Container(
  //             child: Text(
  //               currentUser.userWorkouts[index].getName(),
  //               style: TextStyle(fontSize: 20, color: Colors.white),
  //             ),
  //           ),
  //           Spacer(),
  //           IconButton(
  //             onPressed: () {
  //               setState(() {
  //                 currentWorkout = currentUser.userWorkouts[index];
  //               });
  //             },
  //             icon: Icon(Icons.check_box_outline_blank),
  //           ),
  //           Spacer(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  backgroundColor: Color.fromARGB(255, 230, 230, 230),
                  appBar: MyAppBar(context, true),
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
                    children: <Widget>[
                      for (int index = 0;
                          index < currentUser.getUserWorkouts.length;
                          index += 1)
                        Container(
                          key: Key('$index'),
                          margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            gradient: LinearGradient(colors: primary),
                          ),
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              backgroundColor: Colors.transparent,
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
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      currentWorkout =
                                          currentUser.userWorkouts[index];
                                    });
                                  },
                                  icon: Icon(Icons.check_box_outline_blank),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      await pushWorkoutToDatabase(context);
                    },
                    child: Icon(Icons.add),
                  ),
                ));
      },
    );
  }
}
