import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/Main%20App%20Body/plan/exercise_container.dart';
import 'package:gymchimp/Main%20App%20Body/workout/workout_page.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:numberpicker/numberpicker.dart';
import 'new_workout_page.dart';
import '../workout/workout.dart';
import 'package:reorderables/reorderables.dart';
import 'package:searchable_listview/searchable_listview.dart';

Widget NewWorkoutDeleteButton(BuildContext context, Function onPressed) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        padding: EdgeInsets.all(25),
        primary: Colors.red,
        minimumSize: Size(150, 75)),
    onPressed: () {
      showDialog<String>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
            title: const Text('Are you sure you want to delete this exercise?'),
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
                  onPressed();
                },
              )
            ],
          );
        },
      );
    },
    child: Text("Delete"),
  );
}

//Used for removing the shadow when re-ordering exercises
Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
  return AnimatedBuilder(
    animation: animation,
    builder: (BuildContext context, Widget? child) {
      return Material(
        color: Colors.transparent,
        child: child,
      );
    },
    child: child,
  );
}

void filterSearchResults(String query, Function setState) {
  if (query.isNotEmpty) {
    List<String> dummyListData = [];
    List<String> dummyMuscleListData = [];
    List<String> dummyDifficultyList = [];

    searchList.forEach((element) {
      int ind = searchList.indexOf(element);
      if (element.toLowerCase().contains(query.toLowerCase()) || muscleList[ind].toLowerCase().contains(query.toLowerCase())) {
        dummyListData.add(element);
        dummyMuscleListData.add(muscleList[ind]);
        dummyDifficultyList.add(difficultyList[ind]);

        setState(() {
          exerciseTempList.clear();
          muscleTempList.clear();
          difficultyTempList.clear();

          exerciseTempList.addAll(dummyListData);
          muscleTempList.addAll(dummyMuscleListData);
          difficultyTempList.addAll(dummyDifficultyList);
        });
        return;
      }
    });
  } else {
    setState(() {
      exerciseTempList.clear();
      muscleTempList.clear();
      difficultyTempList.clear();

      exerciseTempList.addAll(searchList);
      muscleTempList.addAll(muscleList);
      difficultyTempList.addAll(difficultyList);
    });
  }
}

void firebaseRemoveExercise(int deleteIndex, bool removeAll, Function setState) async {
  QuerySnapshot querySnapshot = await firestore
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('workouts')
      .doc(workoutIDFirebase)
      .collection('exercises')
      .get();

  List list = querySnapshot.docs;
  list.forEach((element) async {
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(workoutIDFirebase)
        .collection('exercises')
        .doc(element.id)
        .get()
        .then((value) {
      if (value.get('index') == deleteIndex) {
        firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('workouts')
            .doc(workoutIDFirebase)
            .collection('exercises')
            .doc(element.id)
            .delete();
        setState(() {
          if (removeAll) {
            newWorkout.removeExercise(0);
          } else {
            newWorkout.removeExercise(deleteIndex);
          }
          if (newWorkout.exercises.isNotEmpty) {
            updateWorkoutFirebase();
          }
        });
        return;
      }
    });
  });
}

void updateWorkoutFirebase() async {
  QuerySnapshot querySnapshot = await firestore
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('workouts')
      .doc(workoutIDFirebase)
      .collection('exercises')
      .get();

  List list = querySnapshot.docs;
  int i = 0;
  for (var element in list) {
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(workoutIDFirebase)
        .collection('exercises')
        .doc(element.id)
        .get()
        .then((value) async {
      if (i < newWorkout.exercises.length) {
        firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('workouts')
            .doc(workoutIDFirebase)
            .collection('exercises')
            .doc(element.id)
            .update({'index': i, 'name': newWorkout.exercises[i], 'reps': newWorkout.reps[i]});
        i++;
      } else {
        return;
      }
    });
  }
}

void pushExerciseToWorkoutFirebase(int indx) async {
  QuerySnapshot querySnapshot2 = await firestore
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('workouts')
      .doc(workoutIDFirebase)
      .collection('exercises')
      .get();
  List list2 = querySnapshot2.docs;
  List list3 = [];
  list2.forEach((element) async {
    list3.add(element.id);
  });

  int i = 0;
  while (list3.contains("Exercise $i")) {
    i++;
  }

  String exerciseName = "Exercise $i";
  firestore
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('workouts')
      .doc(workoutIDFirebase)
      .collection('exercises')
      .doc(exerciseName)
      .set({'name': newWorkout.getExercise(indx), 'reps': newWorkout.getRepsForExercise(indx), 'index': newWorkout.exercises.length - 1});
}

void getWorkoutID(Function setState) async {
  String id = "";
  QuerySnapshot querySnapshot = await firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('workouts').get();
  var doc;
  bool found = false;
  List list = querySnapshot.docs;
  for (var element in list) {
    doc = await firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('workouts').doc(element.id);
    doc.get().then((value) async {
      if (value.get('name') == newWorkout.getName()) {
        setState(() {
          workoutIDFirebase = element.id;
        });
      }
    });
  }
}
