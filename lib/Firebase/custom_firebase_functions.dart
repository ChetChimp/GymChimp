import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymchimp/customReusableWidgets/DeleteConfirmPopup.dart';
import 'package:gymchimp/main.dart';
import '../Main App Body/plan/new workout page/new_workout_page.dart';

Future<void> updateWorkoutIDFromFirebase() async {
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
        workoutIDFirebase = element.id;
      }
    });
  }
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
      if (i < newWorkout.getLength()) {
        firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('workouts')
            .doc(workoutIDFirebase)
            .collection('exercises')
            .doc(element.id)
            .update({
          'index': i,
          'name': newWorkout.getExercise(i).getName(),
          'reps': newWorkout.getRepsForExercise(i),
        });
        i++;
      } else {
        return;
      }
    });
  }
}

void removeExerciseFromWorkoutFirebase(int deleteIndex) async {
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
        return;
      }
    });
  });
}

Future<void> pushExerciseToWorkoutFirebase(int indx) async {
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
    'name': newWorkout.getExercise(indx).getName(),
    'reps': newWorkout.getRepsForExercise(indx),
    'index': newWorkout.getLength() - 1,
  });
}

Future<void> removeWorkoutFromFirebase(
    BuildContext ctx, Function widgetCallback) async {
  int i = 0;
  while (i < newWorkout.getLength()) {
    removeExerciseFromWorkoutFirebase(i);
    i++;
  }

  await firestore.runTransaction((Transaction myTransaction) async {
    myTransaction.delete(firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(workoutIDFirebase));
  });
  widgetCallback();
}

Future<void> addWorkoutToFirebase(BuildContext ctx, String workoutName) async {
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
