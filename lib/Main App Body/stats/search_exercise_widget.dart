import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/objects/general_loader.dart';
import 'package:gymchimp/objects/workout.dart';
import 'lineChartWidget.dart';
import 'stats_page.dart';

class SearchExercise extends StatefulWidget {
  const SearchExercise({Key? key}) : super(key: key);

  @override
  State<SearchExercise> createState() => _SearchExerciseState();
}

String selectedExerciseName = "";
Workout workoutStats = Workout("empty");
TextEditingController exerciseSearchController =
    TextEditingController(text: "");
List<String> exerciseTempL = [];
List<String> exerciseSearchList = [];
bool focus = false;

class _SearchExerciseState extends State<SearchExercise> {
  @override
  void initState() {
    filterResults("");
    focus = false;
    super.initState();
  }

  void filterResults(String query) {
    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      if (!exerciseSearchList.contains(query)) {
        setState(() {
          exerciseTempL.clear();
          exerciseTempL.add("Search Not Found");
        });
      }
      exerciseSearchList.forEach((element) {
        if (element.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(element);

          setState(() {
            exerciseTempL.clear();
            exerciseTempL.addAll(dummyListData);
          });
          return;
        }
      });
    } else {
      setState(() {
        exerciseTempL.clear();
        exerciseTempL = currentUser.userExerciseList.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          TextField(
            onTap: () {
              setState(() {
                focus = !focus;
              });
            },
            onTapOutside: (event) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            controller: exerciseSearchController,
            style: TextStyle(color: textColor),
            onChanged: (value) {
              setState(() {
                filterResults(value);
              });
            },
            autofocus: focus,
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
                  borderSide: BorderSide(width: 2, color: accentColor)),
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
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
            ),
          ),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.ease,
            //live list of execises
            height: size.height / 4,
            child: ListView.builder(
              itemCount: exerciseTempL.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(3),
                  child: Material(
                    borderRadius: BorderRadius.circular(30),
                    color: foregroundGrey,
                    child: ListTile(
                      enabled: exerciseTempL[index] != "Search Not Found",
                      title: Text(
                        exerciseTempL[index],
                        style: TextStyle(color: textColor),
                      ),
                      // ignore: prefer_interpolation_to_compose_strings
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());

                        generalLoader(context);
                        setState(() {
                          selectedExerciseName = exerciseTempL[index];
                          findExerciseDataConnect(selectedExerciseName);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
