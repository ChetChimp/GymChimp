import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/Main%20App%20Body/home_page.dart';
import 'package:gymchimp/Main%20App%20Body/workout/countdown.dart';
import 'package:gymchimp/Main%20App%20Body/workout/stopwatch.dart';
import 'package:gymchimp/Main%20App%20Body/workout/workoutSummaryPopup.dart';
import 'package:gymchimp/Main%20App%20Body/workout/workout_page.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/objects/exercise.dart';
import '../app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class NextPreviousDoneButton extends StatelessWidget {
  NextPreviousDoneButton({
    Key? key,
    required this.size,
    required this.buttonKey,
    required this.buttonText,
    this.nextOnTop = false,
    this.next1 = false,
  }) : super(key: key);

  final Size size;
  bool nextOnTop;
  bool next1;
  final String buttonText;
  final GlobalKey<State<StatefulWidget>> buttonKey;

  @override
  Widget build(BuildContext context) {
    Alignment alignment;
    Color buttonBackgroundColor = foregroundGrey;
    Color buttonTextColor = accentColor;
    if (buttonText == "Next") {
      alignment = index == 0
          ? Alignment(0, 0)
          : (index == currentWorkout.getNumExercises() - 1
              ? Alignment(-1.5, 0)
              : Alignment(1.5, 0));
    } else if (buttonText == "Previous") {
      alignment = index == 0 ? Alignment.center : Alignment(-1.5, 0);
    } else {
      alignment = index == 0 ? Alignment(0, 0) : Alignment(1.5, 0);
      buttonBackgroundColor = Colors.green;
      buttonTextColor = foregroundGrey;
    }
    return AnimatedContainer(
      curve: Curves.ease,
      duration: Duration(milliseconds: 500),
      width: size.width,
      height: size.height / 10,
      color: Colors.transparent,
      alignment: alignment,
      padding: EdgeInsets.only(left: size.width / 5, right: size.width / 5),
      child: Visibility(
        visible: buttonText == "Next"
            ? next1
                ? nextOnTop
                : !nextOnTop
            : true,
        child: MaterialButton(
          key: buttonKey,
          disabledColor: buttonBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          height: size.height / 20,
          minWidth: size.width / 3,
          onPressed: null,
          child: Text(
            style: TextStyle(fontSize: 26, color: buttonTextColor),
            buttonText,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
