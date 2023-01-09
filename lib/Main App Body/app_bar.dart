import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymchimp/Main%20App%20Body/account_settings.dart';
import 'package:gymchimp/Main%20App%20Body/plan/new_workout_page.dart';
import 'package:gymchimp/Main%20App%20Body/workout/workout_page.dart';
import '../openingScreens/first_time_login.dart';
import 'package:gymchimp/main.dart';
import 'plan/plan_page.dart';
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
bool workoutNameEdit = false;
Icon workoutNameEditIcon = Icon(Icons.edit, color: accentColor);
TextEditingController workoutNameEditController =
    TextEditingController(text: "");

class _MyAppBarState extends State<MyAppBar> {
  Widget middle = Spacer();
  final ctx;
  final arrowEnabled;
  final screenName;
  _MyAppBarState(this.ctx, this.arrowEnabled, this.screenName);

  Radius radius = Radius.circular(30);

  @override
  void initState() {
    stateAddress = setWorkoutListState;
    if (screenName == "new_workout") {
      workoutNameEditController.text =
          currentUser.userWorkouts[workoutIndex].getName();
    }
    super.initState();
  }

  void setWorkoutListState(Workout input) {
    setState(() {});
  }

  void updateWorkoutName() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .get();

    List list = querySnapshot.docs;

    list.forEach((element) {
      var doc = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('workouts')
          .doc(element.id);
      doc.get().then(
        (value) {
          if (value.get("name") ==
              currentUser.userWorkouts[workoutIndex].getName()) {
            doc.set({"name": workoutNameEditController.text});
            nameUpdater(workoutNameEditController.text);
            return;
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        if (screenName != "start_page")
          IconButton(
              splashRadius: 1,
              icon: Icon(Icons.arrow_back_outlined, color: textColor),
              onPressed: () {
                if (Navigator.of(ctx).canPop()) {
                  Navigator.of(ctx).pop();
                } else {
                  Navigator.of(ctx, rootNavigator: true).pop();
                }
              }),
        Spacer(
            //flex: 5,
            ),
        if (screenName == "new_workout")
          Container(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 21),
            width: MediaQuery.of(context).size.width / 1.47,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                Container(
                    width: MediaQuery.of(context).size.width / 1.97,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: foregroundGrey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        autocorrect: true,
                        autofillHints: ["Chest", "Back", "Legs"],
                        enabled: workoutNameEdit,
                        controller: workoutNameEditController)),
                IconButton(
                  onPressed: () {
                    setState(() {
                      workoutNameEdit = !workoutNameEdit;
                      if (workoutNameEdit) {
                        workoutNameEditIcon =
                            Icon(Icons.check, color: accentColor);
                      } else {
                        updateWorkoutName();
                        workoutNameEditIcon =
                            Icon(Icons.edit, color: accentColor);
                      }
                    });
                  },
                  icon: workoutNameEditIcon,
                ),
              ],
            ),
          ),
        if (screenName == "workout_page")
          Container(
            width: MediaQuery.of(ctx).size.width * 5 / 10,
            height: 10,
            //padding: EdgeInsets.all(0),
            //padding: EdgeInsets.all(10),
            child: DropdownButtonHideUnderline(
              child: AnimatedContainer(
                decoration: BoxDecoration(
                    color: foregroundGrey,
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
                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: radius,
                        bottomRight: radius),
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
            icon: Icon(color: textColor, Icons.settings_outlined),
          ),
        ),
      ],
    );
  }

  // }
}
