import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymchimp/openingScreens/first_time_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/openingScreens/start_page.dart';
import 'firebase_options.dart';

class Workout {
  Workout(this.workoutName, this.exerciseList);
  final String workoutName; //Push/Pull/Legs/Arms
  final List exerciseList;
}

class Exercise {
  final String exerciseName;
  final int exerciseType; //0=legs,1=back,2=chest,3=arms
}
