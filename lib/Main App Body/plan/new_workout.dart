import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/Main%20App%20Body/home_page.dart';
import 'package:gymchimp/Main%20App%20Body/plan/plan_page.dart';
import 'package:gymchimp/Main%20App%20Body/workout/exercise.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:numberpicker/numberpicker.dart';
import 'new_workout.dart';
import '../workout/workout.dart';
import 'package:reorderables/reorderables.dart';

import '../app_bar.dart';

class NewWorkout extends StatefulWidget {
  final String workoutName;
  final int index;

  const NewWorkout({Key? key, required this.workoutName, required this.index})
      : super(key: key);

  @override
  State<NewWorkout> createState() =>
      _NewWorkout(workoutName: this.workoutName, index: this.index);
}

class _NewWorkout extends State<NewWorkout> {
  String workoutName;
  int index;
  Workout newWorkout = Workout("");
  _NewWorkout({required this.workoutName, required this.index});

  @override
  void initState() {
    newWorkout = currentUser.userWorkouts[index];
    super.initState();
  }

  TextEditingController exerciseNameField = new TextEditingController(text: "");

  void firebaseRemoveExercise(int deleteIndex) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(newWorkout.getName())
        .collection('exercises')
        .get();

    List list = querySnapshot.docs;
    list.forEach((element) async {
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('workouts')
          .doc(newWorkout.getName())
          .collection('exercises')
          .doc(element.id)
          .get()
          .then((value) {
        if (value.get('name') == newWorkout.exercises[deleteIndex + 1]) {
          firestore
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('workouts')
              .doc(newWorkout.getName())
              .collection('exercises')
              .doc(element.id)
              .delete();
        }
      });
    });
    newWorkout.removeExercise(deleteIndex);
  }

  void removeWorkout(BuildContext ctx) async {
    await firestore.runTransaction((Transaction myTransaction) async {
      await myTransaction.delete(firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('workouts')
          .doc(newWorkout.getName()));
    });
    currentUser.userWorkouts.remove(newWorkout);
    listKey.currentState?.removeItem(index, (context, animation) {
      return fake();
    }, duration: Duration(milliseconds: 1));
    Navigator.of(ctx).pop();
  }

  Widget fake() {
    return Container();
  }

  void updateExerciseIndexFirebase(int index, int newIndex) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(newWorkout.getName())
        .collection('exercises')
        .get();

    List list = querySnapshot.docs;
    list.forEach((element) async {
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('workouts')
          .doc(newWorkout.getName())
          .collection('exercises')
          .doc(element.id)
          .get()
          .then((value) {
        firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('workouts')
            .doc(newWorkout.getName())
            .collection('exercises')
            .doc(element.id)
            .update({'index': newWorkout.exercises.indexOf(value.get('name'))});
      });
    });
  }

  void pushExerciseToWorkoutFirebase(int indx) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(newWorkout.getName())
        .collection('exercises')
        .get();

    List list = querySnapshot.docs;
    List list2 = [];
    list.forEach((element) async {
      list2.add(element.id);
    });

    int i = 0;
    while (list2.contains("Exercise " + i.toString())) {
      i++;
    }

    String exerciseName = "Exercise " + i.toString();
    firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(newWorkout.getName())
        .collection('exercises')
        .doc(exerciseName)
        .set({
      'name': newWorkout.getExercise(indx),
      'reps': newWorkout.getReps(indx),
      'index': i
    });
  }

  Widget build(BuildContext ctx) {
    Size size = MediaQuery.of(context).size;

    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return Material(
            child: child,
          );
        },
        child: child,
      );
    }

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: MyAppBar(context, true),
        body: Center(
          child: ReorderableListView(
            proxyDecorator: proxyDecorator,
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                if (newIndex >= newWorkout.getNumExercises()) {
                  newIndex -= 1;
                }
                newWorkout.swapIndexes(oldIndex, newIndex);

                updateExerciseIndexFirebase(newIndex, oldIndex);
              });
            },
            padding: EdgeInsets.all(8),
            children: <Widget>[
              for (int index = 0;
                  index < newWorkout.getNumExercises();
                  index += 1)
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  key: Key('$index'),
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                    ),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(Icons.drag_indicator),
                        Spacer(),
                        Text(newWorkout.getExercise(index)),
                        Text("    Sets: "),
                        Text(newWorkout.getReps(index).toString()),
                        Spacer(),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.transparent)),
                          child: Icon(Icons.edit),
                          onPressed: () {
                            modifyExercise(
                                ctx, '${newWorkout.getExercise(index)}', index);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              Container(
                  //Add Button
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  key: Key("-1"),
                  height: 200,
                  child: Column(
                    children: [
                      GestureDetector(
                        onLongPress:
                            () {}, //Ensures that the plus button cannot be moved
                        child: OutlinedButton(
                            onPressed: () {
                              modifyExercise(ctx, "", -1);
                            },
                            child: Center(
                              child: Icon(Icons.add),
                            )),
                      ),
                      Container(
                        width: size.width / 2,
                        child: GestureDetector(
                          onLongPress:
                              () {}, //Ensures that the plus button cannot be moved
                          child: OutlinedButton(
                              onPressed: () {
                                removeWorkout(context);
                              },
                              child: Row(
                                children: const [
                                  Spacer(),
                                  Text("Delete Workout",
                                      style: TextStyle(color: Colors.red)),
                                  Spacer(),
                                ],
                              )),
                        ),
                      ),
                    ],
                  ) //),
                  ),
            ],
          ),
        ),
      ),
    );
  }

/*
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
  //Modify Exercise Popup
  void modifyExercise(BuildContext ctx, String name, int changeIndex) {
    //If changeIndex is -1, we are adding a new exercise

    String newName = name;
    exerciseNameField.text = name;
    List<int> reps =
        changeIndex == -1 ? <int>[3] : newWorkout.getReps(changeIndex);

    //sets numReps to a default 3 if making a new workout, or to the current value if modifying workout
    //int numReps = changeIndex == -1 ? 3 : newWorkout.getReps(changeIndex)[0];

    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(35),
        topRight: Radius.circular(35),
      )),
      context: ctx,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(20),
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(30),
                      child: Text("Add/Edit Exercise")),
                  Spacer(),
                  TextField(
                    // decoration:
                    //     InputDecoration(labelText: name, fillColor: Colors.black),
                    controller: exerciseNameField,
                    onChanged: (value) {
                      newName = value;
                    },
                  ),
                  Spacer(),
                  Container(
                    height: 200,
                    child: ListView(
                      padding: EdgeInsets.all(8),
                      children: [
                        for (int i = 0; i < reps.length; i++)
                          Row(
                            children: <Widget>[
                              Text("Reps"),
                              NumberPicker(
                                value: reps[i],
                                minValue: 0,
                                maxValue: 100,
                                itemHeight: 100,
                                axis: Axis.horizontal,
                                onChanged: (value) => setModalState(() {
                                  reps[i] = value;
                                }),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.black26),
                                ),
                              ),
                            ],
                          ),
                        ElevatedButton(
                            onPressed: () {
                              setModalState(() {
                                reps.add(3);
                              });
                            },
                            child: Text("Add new set")),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      Spacer(
                        flex: 3,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              padding: EdgeInsets.all(25),
                              primary: Colors.red,
                              minimumSize: Size(150, 75)),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  title: const Text(
                                      'Are you sure you want to delete this exercise?'),
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
                                        Navigator.pop(ctx);
                                        setState(() async {
                                          if (changeIndex != -1) {
                                            firebaseRemoveExercise(changeIndex);
                                          }
                                        });
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          child: Text("Delete")),
                      Spacer(),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              padding: EdgeInsets.all(25),
                              primary: Colors.blue,
                              minimumSize: Size(150, 75)),
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              if (changeIndex == -1) {
                                newWorkout.addExercise(newName, reps);
                              } else {
                                newWorkout.renameExercise(changeIndex, newName);
                                newWorkout.setReps(changeIndex, reps);
                              }
                            });
                            pushExerciseToWorkoutFirebase(changeIndex == -1
                                ? newWorkout.getNumExercises() - 1
                                : changeIndex);
                          },
                          child: Text("Save")),
                      Spacer(
                        flex: 3,
                      ),
                    ],
                  ),
                  Spacer()
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
