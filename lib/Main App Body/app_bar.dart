import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:gymchimp/Main%20App%20Body/account_settings.dart';
import 'package:gymchimp/Main%20App%20Body/home_page.dart';
import 'package:gymchimp/Main%20App%20Body/start_page.dart';
import 'package:gymchimp/Main%20App%20Body/workout/workout_page.dart';
import '../openingScreens/first_time_login.dart';
import 'package:gymchimp/main.dart';

import 'workout/workout.dart';

void logOutUser(BuildContext ctx) {
  final auth = FirebaseAuth.instance;
  auth.signOut();

  Navigator.of(ctx, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => new FirstLogIn(),
      ),
      (route) => false);
}

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  final ctx;
  final arrowEnabled;
  final screenName;

  MyAppBar(this.ctx, this.arrowEnabled, this.screenName) : super();

  @override
  _MyAppBarState createState() => _MyAppBarState(ctx, arrowEnabled, screenName);

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

Function stateAddress = () {};

List<DropdownMenuItem<String>> emptylist = [];

class _MyAppBarState extends State<MyAppBar> {
  Widget middle = Spacer();
  final ctx;
  final arrowEnabled;
  final screenName;
  _MyAppBarState(this.ctx, this.arrowEnabled, this.screenName);

  @override
  void initState() {
    stateAddress = setWorkoutListState;
    super.initState();
  }

  void setWorkoutListState(Workout input) {
    setState(() {});
  }

  Radius radius = Radius.circular(30);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        if (screenName != "start_page")
          IconButton(
              splashRadius: 1,
              icon: Icon(Icons.arrow_back_outlined, color: Colors.black),
              onPressed: () {
                if (Navigator.of(ctx).canPop()) {
                  Navigator.of(ctx).pop();
                } else {
                  Navigator.of(ctx, rootNavigator: true).pop();
                }
              }),
        Spacer(),
        if (screenName == "workout_page")
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
            width: MediaQuery.of(ctx).size.width * 5 / 10,
            height: 10,
            //padding: EdgeInsets.all(0),
            //padding: EdgeInsets.all(10),
            child: DropdownButtonHideUnderline(
              child: AnimatedContainer(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: radius,
                        bottomRight: radius)),
                duration: const Duration(milliseconds: 250),
                curve: Curves.fastOutSlowIn,
                child: DropdownButton2(
                  onMenuStateChange: (isOpen) {
                    if (isOpen) {
                      setState(() {
                        radius = Radius.circular(0);
                      });
                    } else {
                      setState(() {
                        radius = Radius.circular(30);
                      });
                    }
                  },
                  //buttonPadding: EdgeInsets.all(0),

                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: radius,
                        bottomRight: radius),
                    // gradient: LinearGradient(colors: GradientColors.royalBlue),
                  ),
                  scrollbarAlwaysShow: true,
                  scrollbarRadius: Radius.circular(5),
                  scrollbarThickness: 5,
                  iconSize: 50,
                  iconEnabledColor: accentColor,
                  icon: Visibility(
                      visible: false, child: Icon(Icons.arrow_downward)),
                  isExpanded: true,
                  dropdownMaxHeight: 150,
                  barrierColor: Color.fromARGB(45, 0, 0, 0),
                  hint: Center(
                    child: Text(
                      currentWorkout.getName(),
                      style: TextStyle(color: accentColor),
                    ),
                  ),
                  items: currentUser
                      .getUserWorkoutsString()
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: ((String? value) {
                    setState(() {
                      workoutState(
                          currentWorkout = currentUser.getWorkoutByName(value));
                    });
                  }),
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                  ),
                ),
              ),
            ),
          ),
        Spacer(),
        Container(
          child: PopupMenuButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            itemBuilder: (
              BuildContext context,
            ) =>
                <PopupMenuEntry>[
              PopupMenuItem(
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.person_outline),
                    title: Text('Account', style: TextStyle(fontSize: 16)),
                    onTap: () {
                      changePage(
                        context,
                        new AccountSettings(),
                      );
                    },
                  ),
                ),
              ),
              // PopupMenuItem(
              //   child: new Container(
              //     color: Colors.transparent,
              //     width: 1000,
              //     child: ListTile(
              //       onTap: () {},
              //       leading: Icon(Icons.notifications_outlined),
              //       title: PopupMenuButton(
              //         child: Text("Notifications"),
              //         itemBuilder: (_) {
              //           return [
              //             PopupMenuItem(
              //                 child: ListTile(leading: Text("Item2"))),
              //             PopupMenuItem(child: Text("Item3"))
              //           ];
              //         },
              //       ),
              //     ),
              //   ),
              //   onTap: () {},
              // ),
              PopupMenuItem(
                enabled: true,
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      child: ListTile(
                        onTap: () {},
                        leading: Icon(Icons.scale_outlined),
                        title: Text(weightUnit, style: TextStyle(fontSize: 16)),
                        trailing: Container(
                          child: Switch(
                            // This bool value toggles the switch.
                            value: imperialSystem,
                            activeColor: Colors.blue,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor:
                                Color.fromARGB(131, 255, 73, 73),
                            onChanged: (bool value) {
                              // This is called when the user toggles the switch.
                              setState(() {
                                imperialSystem = value;
                                if (value) {
                                  weightUnit = 'inches/Lbs';
                                } else {
                                  weightUnit = 'cm/Kg';
                                }
                                updateInfo('unit', weightUnit);
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              PopupMenuItem(
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.lock_outline),
                    title: Text('Sign Out', style: TextStyle(fontSize: 16)),
                    onTap: () {
                      while (Navigator.of(ctx).canPop()) {
                        Navigator.of(ctx).pop();
                      }

                      Navigator.of(ctx, rootNavigator: true).pop();

                      logOutUser(context);
                    },
                  ),
                ),
              ),
            ],
            splashRadius: 20,
            icon: Icon(color: Colors.black, Icons.settings_outlined),
          ),
        ),
      ],
    );
  }

  // }
}
