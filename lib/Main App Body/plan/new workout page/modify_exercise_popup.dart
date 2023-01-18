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
import 'package:gymchimp/Main%20App%20Body/plan/new%20workout%20page/exercise_container.dart';
import 'package:gymchimp/Main%20App%20Body/workout/workout_page.dart';
import 'package:gymchimp/main.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../Firebase/custom_firebase_functions.dart';
import '../../../customReusableWidgets/DeleteConfirmPopup.dart';
import '../../../objects/workout.dart';
import 'package:reorderables/reorderables.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../../app_bar.dart';
import 'new_workout_page.dart';
import '../plan page/plan_page.dart';
import 'setChooser.dart';

// Widget NewWorkoutDeleteButton(BuildContext context, Function onPressed) {
//   return
// }

int exerciseLength = 0;
