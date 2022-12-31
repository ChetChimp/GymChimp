import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'stopwatch.dart';

class countdown extends StatefulWidget {
  const countdown({Key? key}) : super(key: key);

  @override
  State<countdown> createState() => _countdownState();
}

Timer? timer;

bool on = true;

int hours = 0;
int minutes = 0;
int seconds = 0;

int savehours = 0;
int saveminutes = 0;
int saveseconds = 0;

double milliseconds = 0;

String hoursString = '0$hours';
String minutesString = '0$minutes';
String secondsString = '0$seconds';

TextStyle fontstyle(Size size) {
  return TextStyle(
      fontSize: size.width / 8,
      //fontWeight: FontWeight.bold,
      color: Colors.black,
      letterSpacing: 1,
      decoration: TextDecoration.none);
}

class _countdownState extends State<countdown>
    with AutomaticKeepAliveClientMixin {
  Card timePicker(Size size) {
    return Card(
      margin: EdgeInsets.only(
          right: size.width / 14,
          left: size.width / 14,
          bottom: size.height / 3,
          top: size.height / 3),
      child: CupertinoTimerPicker(
        onTimerDurationChanged: ((Duration value) {
          setState(() {
            int time = value.inSeconds;
            hours = time ~/ 3600;
            time %= 3600;
            minutes = time ~/ 60;
            time %= 60;
            seconds = time;
            if (hours > 9) {
              hoursString = hours.toString();
            } else {
              hoursString = '0$hours';
            }
            if (minutes > 9) {
              minutesString = minutes.toString();
            } else {
              minutesString = '0$minutes';
            }
            if (seconds > 9) {
              secondsString = seconds.toString();
            } else {
              secondsString = '0$seconds';
            }
            savehours = hours;
            saveminutes = minutes;
            saveseconds = seconds;
          });
        }),
      ),
    );
  }

  void _openPicker(Size size) {
    setState(() {
      hours = 0;
      minutes = 0;
      seconds = 0;
      savehours = 0;
      saveminutes = 0;
      saveseconds = 0;
      hoursString = '0$hours';
      minutesString = '0$minutes';
      secondsString = '0$seconds';
    });

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return timePicker(size);
        });
  }

  void _beginTimer() {
    if (hours == 0 && minutes == 0 && (seconds - 1 == 0 || seconds == 0)) {
      on = true;
      seconds = 0;
      secondsString = '0$seconds';
      _stopTimer();
      return;
    }
    timer = Timer.periodic(const Duration(seconds: 1), (_) => reduceTime());
  }

  void _stopTimer() {
    setState(() => timer?.cancel());
  }

  void _resetTimer() {
    setState(() {
      hours = savehours;
      minutes = saveminutes;
      seconds = saveseconds;
      if (hours > 9) {
        hoursString = hours.toString();
      } else {
        hoursString = '0$hours';
      }
      if (minutes > 9) {
        minutesString = minutes.toString();
      } else {
        minutesString = '0$minutes';
      }
      if (seconds > 9) {
        secondsString = seconds.toString();
      } else {
        secondsString = '0$seconds';
      }
    });
  }

  void reduceTime() {
    if (mounted) {
      setState(() {
        if (hours == 0 && minutes == 0 && (seconds - 1 == 0 || seconds == 0)) {
          on = true;
          seconds = 0;
          secondsString = '0$seconds';
          _stopTimer();
          return;
        } else if (hours != 0 && seconds - 1 == -1 && minutes == 0) {
          hours -= 1;
          minutes = 59;
          minutesString = minutes.toString();
          seconds = 59;
          secondsString = seconds.toString();
          if (hours > 9) {
            hoursString = hours.toString();
          } else {
            hoursString = '0$hours';
          }
        } else if (minutes != 0 && seconds - 1 == -1) {
          minutes -= 1;
          seconds = 59;
          secondsString = seconds.toString();
          if (minutes > 9) {
            minutesString = minutes.toString();
          } else {
            minutesString = '0$minutes';
          }
        } else {
          seconds -= 1;
          if (seconds > 9) {
            secondsString = seconds.toString();
          } else {
            secondsString = '0$seconds';
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(8.0),
      //     boxShadow: const [
      //       BoxShadow(
      //           color: Colors.black12,
      //           offset: Offset(0.0, 10.0),
      //           blurRadius: 15.0),
      //       BoxShadow(
      //           color: Colors.black12,
      //           offset: Offset(0.0, -10.0),
      //           blurRadius: 10.0),
      //     ]),
      // height: size.height / 6,
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Text("Countdown Timer",
              style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              timeCard(hoursString, size),
              Text(
                ':',
                style: TextStyle(
                    fontSize: size.width / 8,
                    //fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                    decoration: TextDecoration.none),
              ),
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
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    _beginTimer();
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
                    Icons.restore,
                    size: size.width / 10,
                  )),
              const Spacer(),
              IconButton(
                  color: Colors.white,
                  splashRadius: .01,
                  onPressed: () => _openPicker(size),
                  icon: Icon(
                    Icons.edit,
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
