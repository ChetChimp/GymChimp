import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../app_bar.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPage();
}

Timer? timer;
int hours = 0;
int minutes = 0;
int seconds = 0;
int milliseconds = 0;

String hoursString = '0' + hours.toString();
String minutesString = '0' + minutes.toString();
String secondsString = '0' + seconds.toString();
String millisecondsString = '0' + milliseconds.toString();

class _WorkoutPage extends State<WorkoutPage> {
  void _beginTimer() {
    timer = Timer.periodic(Duration(milliseconds: 1), (_) => addTime());
  }

  void _stopTimer() {
    setState(() => timer?.cancel());
  }

  void _resetTimer() {
    setState(() {
      hours = 0;
      minutes = 0;
      seconds = 0;
      milliseconds = 0;
      hoursString = '0' + hours.toString();
      minutesString = '0' + minutes.toString();
      secondsString = '0' + seconds.toString();
      millisecondsString = '0' + milliseconds.toString();
    });
  }

  void addTime() {
    setState(() {
      if (milliseconds + 1 == 1000 && seconds + 1 == 60 && minutes + 1 == 60) {
        minutes = 0;
        minutesString = '0$minutes';
        seconds = 0;
        secondsString = '0$seconds';
        milliseconds = 0;
        millisecondsString = '0$milliseconds';
        hours += 1;
        if (hours > 9) {
          hoursString = hours.toString();
        } else {
          hoursString = '0' + hours.toString();
        }
      } else if (milliseconds + 1 == 1000 && seconds + 1 == 60) {
        seconds = 0;
        secondsString = '0$seconds';
        milliseconds = 0;
        millisecondsString = '0$milliseconds';
        minutes += 1;
        if (minutes > 9) {
          minutesString = minutes.toString();
        } else {
          minutesString = '0' + minutes.toString();
        }
      } else if (milliseconds + 1 == 1000) {
        milliseconds = 0;
        millisecondsString = '0$milliseconds';
        seconds += 1;
        if (seconds > 9) {
          secondsString = seconds.toString();
        } else {
          secondsString = '0' + seconds.toString();
        }
      } else {
        milliseconds += 1;
        millisecondsString = '0$milliseconds';
        if (milliseconds > 9) {
          millisecondsString = milliseconds.toString().substring(0, 2);
        } else {
          millisecondsString = '0' + milliseconds.toString();
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Navigator(onGenerateRoute: (settings) {
      return MaterialPageRoute(
        builder: (_) => MaterialApp(
          title: 'Welcome to Flutter',
          home: Scaffold(
            appBar: MyAppBar(context, true),
            body: Center(
                child: Container(
              alignment: Alignment.centerRight,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        hoursString,
                      ),
                      const Text(
                        ':',
                      ),
                      Text(
                        minutesString,
                      ),
                      const Text(
                        ':',
                      ),
                      Text(
                        secondsString,
                      ),
                      const Text(
                        '.',
                      ),
                      Text(
                        millisecondsString,
                      )
                    ],
                  ),
                  ElevatedButton(onPressed: _beginTimer, child: Text("Start")),
                  ElevatedButton(onPressed: _stopTimer, child: Text("Stop")),
                  ElevatedButton(onPressed: _resetTimer, child: Text("Reset")),
                ],
              ),
            )),
          ),
        ),
      );
    });
  }
}
