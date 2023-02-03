import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gymchimp/Firebase/custom_firebase_functions.dart';
import 'package:gymchimp/Main%20App%20Body/plan/new%20workout%20page/setChooser.dart';
import 'package:gymchimp/Main%20App%20Body/workout/workout_page.dart';
import 'package:gymchimp/main.dart';
import '../../../customReusableWidgets/DeleteConfirmPopup.dart';

void workoutSummary({
  required BuildContext ctx,

  //required Function setState,
}) {
  //If changeIndex is -1, we are adding a new exercise
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  //final GlobalKey<AnimatedListState> _listKey2 =
  //GlobalKey<AnimatedListState>();

  //sets numReps to a default 3 if making a new workout, or to the current value if modifying workout
  //int numReps = changeIndex == -1 ? 3 : newWorkout.getReps(changeIndex)[0];

  showModalBottomSheet<void>(
    //enableDrag: false,  //turned off for testing, uncomment later
    backgroundColor: backgroundGrey,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(35))),
    context: ctx,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        child: FractionallySizedBox(
          heightFactor: 1,
          child: StatefulBuilder(
              builder: (BuildContext context2, StateSetter setModalState) {
            Size size = MediaQuery.of(context).size;
            final ScrollController _animatedScrollController =
                ScrollController();

            return Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(35)),
              ),
              padding: EdgeInsets.all(15),
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //New/Edit Exercise Title
                  Container(
                      margin: EdgeInsets.all(30),
                      child: Text("Workout Saved",
                          style: TextStyle(color: Colors.black, fontSize: 35))),
                  //Exercise Chooser
                ],
              ),
            );
          }),
        ),
      );
    },
  );
}
