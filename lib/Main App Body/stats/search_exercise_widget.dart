import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/objects/workout.dart';

class SearchExercise extends StatefulWidget {
  const SearchExercise({Key? key}) : super(key: key);

  @override
  State<SearchExercise> createState() => _SearchExerciseState();
}

String selectedWorkoutName = "";
Workout workoutStats = Workout("empty");
TextEditingController exerciseSearchController =
    TextEditingController(text: "");
List<String> exerciseTempL = [];
List<String> exerciseSearchList = [];

class _SearchExerciseState extends State<SearchExercise> {
  @override
  void initState() {
    filterResults("");
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
            height: size.height / 1.75,
            child: ListView.builder(
              itemCount: exerciseTempL.length,
              itemBuilder: (context, index) {
                return Container(
                  // decoration: BoxDecoration(
                  //   border: Border(
                  //       bottom: BorderSide(color: accentColor, width: 2)),
                  // ),
                  child: Material(
                    color: index % 2 == 0 ? backgroundGrey : foregroundGrey,
                    child: ListTile(
                      enabled: exerciseTempL[index] != "Search Not Found",
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
    );
  }
}
