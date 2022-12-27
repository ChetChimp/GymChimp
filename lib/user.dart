import 'dart:collection';

import 'package:gymchimp/Main%20App%20Body/plan/exercises.dart';
import 'package:gymchimp/Main%20App%20Body/plan/workout.dart';

class CurrentUser {
  var name;
  var email;
  var gender;

  var units;
  var level;

  List<Workout> userWorkouts = <Workout>[];

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

  set setUserWorkouts(userWorkouts) => this.userWorkouts = userWorkouts;

  void addWorkout(Workout newWorkout) {
    userWorkouts.add(newWorkout);
  }

  void removeWorkout(Workout newWorkout) {
    userWorkouts.remove(newWorkout);
  }
}
