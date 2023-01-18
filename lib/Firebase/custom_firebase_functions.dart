import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymchimp/customReusableWidgets/DeleteConfirmPopup.dart';
import 'package:gymchimp/main.dart';
import '../Main App Body/plan/new workout page/new_workout_page.dart';

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
      if (element.toLowerCase().contains(query.toLowerCase()) ||
          muscleList[ind].toLowerCase().contains(query.toLowerCase())) {
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

void firebaseRemoveExercise(
    int deleteIndex, bool removeAll, Function setState) async {
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
        WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
              // if (removeAll) {
              //   newWorkout.removeExercise(0);
              // } else {
              //   newWorkout.removeExercise(deleteIndex);
              // }
              // if (newWorkout.exercises.isNotEmpty) {
              //   updateWorkoutFirebase();
              // }

              print(newWorkout.getNumExercises());
              print(newWorkout.getExercisesList().toString());
            }));
        //setState(() {
        //newWorkout.removeExercise(0);
        //});
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
            .update({
          'index': i,
          'name': newWorkout.exercises[i],
          'reps': newWorkout.reps[i]
        });
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
      .set({
    'name': newWorkout.getExercise(indx),
    'reps': newWorkout.getRepsForExercise(indx),
    'index': newWorkout.exercises.length - 1
  });
}

void getWorkoutID(Function setState) async {
  String id = "";
  QuerySnapshot querySnapshot = await firestore
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('workouts')
      .get();
  var doc;
  bool found = false;
  List list = querySnapshot.docs;
  for (var element in list) {
    doc = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(element.id);
    doc.get().then((value) async {
      if (value.get('name') == newWorkout.getName()) {
        setState(() {
          workoutIDFirebase = element.id;
        });
      }
    });
  }
}
