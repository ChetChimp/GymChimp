import 'dart:collection';

import 'package:gymchimp/Main%20App%20Body/workout/workout_page.dart';
import 'package:gymchimp/objects/exercise.dart';

class Workout {
  String name;

  List<Exercise> _exercises = <Exercise>[];
  //List<List<int>> _reps = <List<int>>[];

  Workout(this.name);

  void addExerciseByName(String exerciseName, List<int> reps) {
    _exercises.add(Exercise.withReps(exerciseName, _exercises.length, reps));
  }

  int getLength() {
    return _exercises.length;
  }

  void initializeLists(int length) {
    _exercises =
        List<Exercise>.filled(length, Exercise("Error", -1), growable: true);
    // _reps = List<List<int>>.filled(length, [], growable: true);
  }

  void setRepsAtIndex(int index, List<int> reps) {
    _exercises[index].setReps(reps);
    // _reps[index] = reps;
  }

  void setExerciseAtIndex(int index, Exercise exercise) {
    _exercises[index] = exercise;
  }

  void removeExercise(int index) {
    _exercises.removeAt(index);
    // _reps.removeAt(index);
  }

  void renameExercise(int index, String newExerciseName) {
    _exercises[index].setName(newExerciseName);
  }

  String getName() {
    return name;
  }

  List<Exercise> getExercisesList() {
    return _exercises;
  }

  List<int> getRepsForExercise(int index) {
    return _exercises[index].getReps();
  }

  // String printReps(int index) {
  //   String returnString = "";
  //   List<int> reps = getRepsForExercise(index);
  //   int i = 1;
  //   for (var element in reps) {
  //     returnString += element.toString() + ", ";
  //     i++;
  //   }
  //   return returnString;
  // }

  Exercise getExercise(int index) {
    return _exercises[index];
  }

  void moveExercise(int oldIndex, int newIndex) {
    Exercise tempExercise = _exercises.removeAt(oldIndex);
    _exercises.insert(newIndex, tempExercise);
    // List<int> tempRep = _reps.removeAt(oldIndex);
    // _reps.insert(newIndex, tempRep);
  }

  @override
  String toString() {
    return _exercises.toString();
  }

//***************************************************//
//Live Workout functions

  bool live = false;

  void goLive() {
    live = true;
    for (Exercise exercise in _exercises) {
      exercise.goLive();
    }
  }

  void endLive() {
    live = false;
    for (Exercise exercise in _exercises) {
      exercise.endLive();
    }
  }

  bool isLive() {
    return live;
  }
}
