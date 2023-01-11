import 'dart:collection';

import 'package:gymchimp/Main%20App%20Body/plan/exercises.dart';
import 'package:gymchimp/Main%20App%20Body/workout/workout.dart';

class CurrentUser {
  var name;
  var email;
  var gender;

  var units;
  var level;

  List<Workout> userWorkouts = <Workout>[];

  void moveWorkout(int oldIndex, int newIndex) {
    Workout tempWorkout = userWorkouts.removeAt(oldIndex);
    userWorkouts.insert(newIndex, tempWorkout);
  }

  CurrentUser();

  String get getName => this.name;

  set setName(String name) => this.name = name;

  get getEmail => this.email;

  set setEmail(email) => this.email = email;

  get getGender => this.gender;

  set setGender(gender) => this.gender = gender;

  get getUnits => this.units;

  set setUnits(units) => this.units = units;

  get getLevel => this.level;

  set setLevel(level) => this.level = level;

  get getUserWorkouts => this.userWorkouts;

  void addAllInfo(
      String name, String email, String gender, String units, String level) {
    this.name = name;
    this.email = email;
    this.gender = gender;
    this.units = units;
    this.level = level;
  }

  List<String> getUserWorkoutsString() {
    List<String> userWorkoutsString = <String>[];
    for (Workout w in userWorkouts) {
      userWorkoutsString.add(w.name);
    }
    return userWorkoutsString;
  }

  Workout getWorkoutByName(String? name) {
    for (Workout w in userWorkouts) {
      if (w.getName() == name) {
        return w;
      }
    }
    return Workout("Empty Workout");
  }

  get getNumWorkouts => this.userWorkouts.length;

  set setUserWorkouts(userWorkouts) => this.userWorkouts = userWorkouts;

  void addWorkout(Workout newWorkout) {
    userWorkouts.add(newWorkout);
  }

  void removeWorkout(Workout newWorkout) {
    userWorkouts.remove(newWorkout);
  }

  @override
  String toString() {
    String s = "Name: " + name + ", Email: " + email;
    return s;
  }
}
