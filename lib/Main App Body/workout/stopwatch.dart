import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/main.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({Key? key}) : super(key: key);

  @override
  State<StopWatch> createState() => _StopWatchState();
}

Timer? timer;

bool on = true;

int hours = 0;
int minutes = 0;
int seconds = 0;
double milliseconds = 0;

String hoursString = '0$hours';
String minutesString = '0$minutes';
String secondsString = '0$seconds';
String millisecondsString =
    milliseconds.toString().substring(0, 1).padLeft(2, '0');

TextStyle fontstyle(Size size) {
  return TextStyle(
      fontSize: size.width / 8,
      //fontWeight: FontWeight.bold,
      color: Colors.black,
      letterSpacing: 1,
      decoration: TextDecoration.none);
}

class _StopWatchState extends State<StopWatch>
    with AutomaticKeepAliveClientMixin {
  void addTime() {
    if (mounted) {
      setState(() {
        if (milliseconds + 1.24133004 >= 1000 &&
            seconds + 1 == 60 &&
            minutes + 1 == 60) {
          hours += 1;

          minutes = 0;
          minutesString = '0$minutes';
          seconds = 0;
          secondsString = '0$seconds';
          milliseconds = 0;
          millisecondsString =
              milliseconds.toString().substring(0, 1).padLeft(2, '0');
          if (hours > 9) {
            hoursString = hours.toString();
          } else {
            hoursString = '0$hours';
          }
        } else if (milliseconds + 1.24133004 >= 1000 && seconds + 1 == 60) {
          minutes += 1;

          seconds = 0;
          secondsString = '0$seconds';
          milliseconds = 0;
          millisecondsString =
              milliseconds.toString().substring(0, 1).padLeft(2, '0');
          if (minutes > 9) {
            minutesString = minutes.toString();
          } else {
            minutesString = '0$minutes';
          }
        } else if (milliseconds + 1.24133004 >= 1000) {
          seconds += 1;

          milliseconds = 0;
          millisecondsString =
              milliseconds.toString().substring(0, 1).padLeft(2, '0');
          if (seconds > 9) {
            secondsString = seconds.toString();
          } else {
            secondsString = '0$seconds';
          }
        } else {
          milliseconds += 1.24133004;
          millisecondsString =
              milliseconds.toString().substring(0, 1).padLeft(2, '0');
          if (milliseconds > 9) {
            millisecondsString = milliseconds.toString().substring(0, 2);
          } else {
            millisecondsString = milliseconds.toString().substring(0, 1);
          }
        }
      });
    }
  }

  void _beginStopWatch() {
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
      hoursString = '0$hours';
      minutesString = '0$minutes';
      secondsString = '0$seconds';
      millisecondsString =
          milliseconds.toString().substring(0, 1).padLeft(2, '0');
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 6,
      child: Column(
        children: [
          Text("Stopwatch",
              style: GoogleFonts.quicksand(color: Colors.white, fontSize: 24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              timeCard(hoursString, size),
              Text(':',
                  style: TextStyle(
                      fontSize: size.width / 8,
                      //fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                      decoration: TextDecoration.none)),
              timeCard(minutesString, size),
              Text(
                ':',
                style: TextStyle(
                    fontSize: size.width / 8,
                    //fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                    decoration: TextDecoration.none),
              ),
              timeCard(secondsString, size),
              Text(
                '.',
                style: TextStyle(
                    fontSize: size.width / 8,
                    //fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                    decoration: TextDecoration.none),
              ),
              timeCard(millisecondsString, size)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              IconButton(
                splashRadius: .01,
                icon: on
                    ? Icon(
                        color: Colors.white,
                        Icons.play_arrow_sharp,
                        size: size.width / 8,
                      )
                    : Icon(Icons.stop_rounded, size: size.width / 8),
                onPressed: (() {
                  setState(() {
                    on = !on;
                  });
                  if (!on) {
                    _beginStopWatch();
                  } else {
                    _stopTimer();
                  }
                }),
              ),
              const Spacer(),
              IconButton(
                  color: Colors.white,
                  splashRadius: .01,
                  onPressed: _resetTimer,
                  icon: Icon(
                    Icons.replay_sharp,
                    size: size.width / 10,
                  )),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class timeCard extends StatefulWidget {
  final String timeUnit;
  final Size sizeOfScreen;
  timeCard(this.timeUnit, this.sizeOfScreen, {Key? key}) : super(key: key);

  @override
  State<timeCard> createState() => _timeCardState();
}

class _timeCardState extends State<timeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3,
      child: Container(
        padding: EdgeInsets.only(top: 4, bottom: 4),
        width: widget.sizeOfScreen.width / 6 + 4,
        child: Text(
          widget.timeUnit,
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            textStyle: fontstyle(widget.sizeOfScreen),
          ),
        ),
      ),
    );
  }
}
