import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gymchimp/Main%20App%20Body/app_bar.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/objects/workout.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

Radius radius = Radius.circular(30);
String selectedWorkoutName = "";
Workout workoutStats = Workout("empty");

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => MaterialApp(
            home: Scaffold(
              backgroundColor: backgroundGrey,
              appBar: MyAppBar(context, false, "stats_page"),
              body: Column(
                children: [
                  Center(
                    child: AnimatedContainer(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: radius,
                            bottomRight: radius),
                        color: accentColor,
                      ),
                      duration: Duration(milliseconds: 200),
                      child: DropdownButtonHideUnderline(
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
                          buttonWidth: size.width - 10,
                          buttonHeight: size.height / 14,
                          scrollbarAlwaysShow: true,
                          scrollbarRadius: Radius.circular(5),
                          scrollbarThickness: 5,
                          iconSize: 50,
                          dropdownMaxHeight: size.height / 3,
                          iconEnabledColor: foregroundGrey,
                          isExpanded: true,
                          barrierColor: Color.fromARGB(45, 0, 0, 0),
                          hint: Text(selectedWorkoutName,
                              style: TextStyle(
                                  color: foregroundGrey,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500)),
                          items: currentUser
                              .getUserWorkoutsString()
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedWorkoutName = value!;
                              workoutStats = currentUser
                                  .getWorkoutByName(selectedWorkoutName);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: size.height / 3,
                    child: ListView.builder(
                      itemCount: workoutStats.exercises.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Text(workoutStats.exercises[index])),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
        // WidgetBuilder builder;
        // builder = (BuildContext _) =>
      },
    );
  }
}
