import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gymchimp/Main%20App%20Body/app_bar.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/objects/workout.dart';

import '../plan/new workout page/new_workout_page.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

Radius radius = Radius.circular(30);
String selectedWorkoutName = "";
Workout workoutStats = Workout("empty");
TextEditingController exerciseSearchController =
    TextEditingController(text: "");
List<String> exerciseTempL = [];
List<String> exerciseSearchList = [];

class _StatsPageState extends State<StatsPage> {
  @override
  void initState() {
    exerciseTempL = currentUser.userExerciseList.toList();
    exerciseSearchList = currentUser.userExerciseList.toList();
    filterResults("");
    super.initState();
  }

  void filterResults(String query) {
    if (query.isNotEmpty) {
      List<String> dummyListData = [];

      exerciseSearchList.forEach((element) {
        if (element.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(element);

          setState(() {
            exerciseTempL.clear();
            exerciseTempL.addAll(dummyListData);
          });
          print(exerciseTempL);
          return;
        }
      });
    } else {
      setState(() {
        print(exerciseTempL);
        exerciseTempL.clear();
        exerciseTempL = currentUser.userExerciseList.toList();
      });
    }
  }

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
              body: Container(
                child: Column(
                  children: [
                    TextField(
                      controller: exerciseSearchController,
                      style: TextStyle(color: textColor),
                      onChanged: (value) {
                        setState(() {
                          filterResults(value);
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                            width: 2,
                            color: accentColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide:
                                BorderSide(width: 2, color: accentColor)),
                        //fillColor: textColor,
                        labelText: "Search",
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.white),
                        focusColor: textColor,
                        floatingLabelStyle: TextStyle(color: textColor),
                        prefixIcon: Icon(
                          Icons.search,
                          color: accentColor,
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0))),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.ease,
                      //live list of execises
                      height: size.height / 3.75,
                      child: ListView.builder(
                        itemCount: exerciseTempL.length,
                        itemBuilder: (context, index) {
                          return Container(
                            // decoration: BoxDecoration(
                            //   border: Border(
                            //       bottom: BorderSide(color: accentColor, width: 2)),
                            // ),
                            child: Material(
                              color: index % 2 == 0
                                  ? backgroundGrey
                                  : foregroundGrey,
                              child: ListTile(
                                title: Text(
                                  exerciseTempL[index],
                                  style: TextStyle(color: textColor),
                                ),
                                // ignore: prefer_interpolation_to_compose_strings
                                onTap: () {
                                  setState(() {});
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
