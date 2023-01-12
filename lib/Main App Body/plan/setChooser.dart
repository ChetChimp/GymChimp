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
import 'package:gymchimp/Main%20App%20Body/workout/workout_page.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:numberpicker/numberpicker.dart';
import 'new_workout_page.dart';
import '../workout/workout.dart';
import 'package:reorderables/reorderables.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../app_bar.dart';
import 'plan_page.dart';

class setChooser extends StatelessWidget {
  const setChooser({
    required GlobalKey<AnimatedListState> listKey,
    Key? key,
    required this.setStateParent,
    //required this.removeItem,
    required this.reps,
    required this.index,
    required this.animation,
    required this.tempValue,
    required this.choosingExerciseTrue,
  })  : _listKey = listKey,
        super(key: key);

  final int index;
  final int tempValue;
  final List<int> reps;
  final Function setStateParent;
  //final Function removeItem;
  final Function choosingExerciseTrue;
  final Animation<double> animation;
  final GlobalKey<AnimatedListState> _listKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Set " + (index + 1).toString(),
            style: TextStyle(color: textColor),
          ),
          NumberPicker(
            haptics: true,
            textStyle: TextStyle(color: textColor),
            selectedTextStyle: TextStyle(color: accentColor, fontSize: 30),
            value: tempValue < 0 ? reps[index] : tempValue,
            minValue: 0,
            maxValue: 50,
            itemHeight: 75,
            itemWidth: 75,
            axis: Axis.horizontal,
            onChanged: (value) {
              choosingExerciseTrue();
              if (tempValue < 0) {
                reps[index] = value;
                setStateParent();
              }
            },
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: accentColor),
              //color: textColor,
            ),
          ),
          // IconButton(
          //   onPressed: () {
          //     if (tempValue > 0 || reps.length <= 1) {
          //       return null;
          //     } else {
          //       removeItem(index);
          //     }
          //     choosingExerciseTrue();
          //     setStateParent();
          //   },
          //   icon: Icon(
          //     Icons.delete,
          //     color: accentColor,
          //     size: 25,
          //   ),
          // )
        ],
      ),
    );
  }
}
