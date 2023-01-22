import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymchimp/Main%20App%20Body/plan/plan%20page/plan_page.dart';
import 'package:gymchimp/customReusableWidgets/DeleteConfirmPopup.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/objects/workout.dart';
import '../Main App Body/plan/new workout page/new_workout_page.dart';

Future<void> updateWorkoutIDFromFirebase(Workout workout) async {
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
      if (value.get('name') == workout.getName()) {
        workoutIDFirebase = element.id;
      }
    });
  }
}

void updateWorkoutFirebase(Workout workout) async {
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
      if (i < workout.getLength()) {
        firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('workouts')
            .doc(workoutIDFirebase)
            .collection('exercises')
            .doc(element.id)
            .update({
          'index': i,
          'name': workout.getExercise(i).getName(),
          'reps': workout.getExercise(i).getReps(),
        });
        i++;
      } else {
        return;
      }
    });
  }
}

Future<void> removeWorkoutFromFirebase(
    BuildContext ctx, Workout workout) async {
  int i = 0;
  while (i < workout.getLength()) {
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
  planPageSetState(() => {});
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

Future<void> pushExerciseToWorkoutFirebase(Workout workout, int indx) async {
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
    'name': workout.getExercise(indx).getName(),
    'reps': workout.getExercise(indx).getReps(),
    'index': workout.getLength() - 1,
  });
}

Future<void> addWorkoutToFirebase(BuildContext ctx, Workout workout) async {
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
  workout.setName("Untitled Workout [" + i.toString() + "]");

  await firestore
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('workouts')
      .doc(workout.getName())
      .set({'name': workout.getName()});
}

void updateWorkoutName(Workout workout, String newName) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('workouts')
      .get();

  List list = querySnapshot.docs;

  list.forEach((element) {
    var doc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(element.id);
    doc.get().then(
      (value) {
        if (value.get("name") == workout.getName()) {
          doc.update({"name": newName});
          planPageSetState(() => workout.setName(newName));
          return;
        }
      },
    );
  });
}