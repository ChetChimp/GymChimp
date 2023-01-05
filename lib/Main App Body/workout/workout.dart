import 'dart:collection';

import 'package:gymchimp/Main%20App%20Body/plan/exercises.dart';

class Workout {
  var name;
  var index;
  List<String> exercises = <String>[];
  List<List<int>> reps = <List<int>>[];

  Workout(this.name);

  void addExercise(String name, List<int> reps) {
    exercises.add(name);
    this.reps.add(reps);
  }

  void setReps(int index, List<int> reps) {
    this.reps[index] = reps;
  }

  void removeExercise(int index) {
    exercises.removeAt(index);
    reps.removeAt(index);
  }

  void renameExercise(int index, String newExercise) {
    exercises[index] = newExercise;
  }

  String getName() {
    return name;
  }

  int getNumExercises() {
    return exercises.length;
  }

  List<int> getReps(int index) {
    return reps[index];
  }

  String getExercise(int index) {
    if (exercises.isEmpty) {
      return "";
    }
    return exercises[index];
  }

  void moveExercise(int oldIndex, int newIndex) {
    String tempExercise = exercises.removeAt(oldIndex);
    exercises.insert(newIndex, tempExercise);
    List<int> tempRep = reps.removeAt(oldIndex);
    reps.insert(newIndex, tempRep);
  }

  void setIndex(int input) {
    index = input;
  }
}
