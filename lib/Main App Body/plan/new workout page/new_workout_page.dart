import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/Main%20App%20Body/plan/new%20workout%20page/exercise_container.dart';
import 'package:gymchimp/Main%20App%20Body/plan/new%20workout%20page/modify_exercise_popup.dart';
import 'package:gymchimp/Firebase/custom_firebase_functions.dart';
import 'package:gymchimp/Main%20App%20Body/workout/workout_page.dart';
import 'package:gymchimp/main.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../customReusableWidgets/DeleteConfirmPopup.dart';
import '../../app_bar.dart';
import '../../../objects/workout.dart';
import 'package:reorderables/reorderables.dart';
import 'package:searchable_listview/searchable_listview.dart';

class NewWorkoutPage extends StatefulWidget {
  final String workoutName;
  final int index;
  final Function callback;

  const NewWorkoutPage(
      {Key? key,
      required this.workoutName,
      required this.index,
      required this.callback})
      : super(key: key);

  @override
  State<NewWorkoutPage> createState() => _NewWorkoutPage(index: this.index);
}

var workoutIndex;
Workout newWorkout = Workout("");
//Function modExercise = () {};
List<String> exerciseTempList = [];
List<String> difficultyTempList = [];
List<String> muscleTempList = [];

List<String> searchList = [];
List<String> difficultyList = [];
List<String> muscleList = [];
String workoutIDFirebase = "";

class _NewWorkoutPage extends State<NewWorkoutPage> {
  int index;
  _NewWorkoutPage({required this.index});
  List<Map<String, String>> data = [];

  @override
  void initState() {
    workoutIndex = index;
    newWorkout = currentUser.userWorkouts[index];
    getWorkoutID(setState);
    readJson();
    super.initState();
  }

  Future<void> removeWorkout(
    BuildContext ctx,
  ) async {
    print("Test");

    int i = 0;
    while (i < newWorkout.exercises.length) {
      firebaseRemoveExercise(i, true, setState);
      i++;
    }

    await firestore.runTransaction((Transaction myTransaction) async {
      myTransaction.delete(firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('workouts')
          .doc(workoutIDFirebase));
    });
    widget.callback(widget.index);
  }

  void getWorkoutID(setState) async {
    String id = "";
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .get();
    var doc;
    bool found = false;
    List list = querySnapshot.docs;
    for (var element in list) {
      doc = await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('workouts')
          .doc(element.id);
      doc.get().then((value) async {
        if (value.get('name') == newWorkout.getName()) {
          setState(() {
            workoutIDFirebase = element.id;
          });
        }
      });
    }
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('json/exerciseList.json');
    List map = await json.decode(response);
    map.forEach(
      (element) {
        searchList.add(element['exercise']);
        difficultyList.add(element['difficulty']);
        muscleList.add(element['muscle']);

        exerciseTempList.add(element['exercise']);
        difficultyTempList.add(element['difficulty']);
        muscleTempList.add(element['muscle']);

        data.add({
          'muscle': element['muscle'],
          'exercise': element['exercise'],
          "difficulty": element["difficulty"]
        });
      },
    );
  }

  Widget build(BuildContext ctx) {
    Size size = MediaQuery.of(context).size;
    return Navigator(onGenerateRoute: (settings) {
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                backgroundColor: backgroundGrey,
                appBar: MyAppBar(context, true, "new_workout"),
                body: Container(
                  child: Column(
                    children: [
                      Container(
                        height: size.height * (3.6 / 5),
                        child: ReorderableListView(
                          proxyDecorator: proxyDecorator,
                          onReorder: (int oldIndex, int newIndex) {
                            setState(() {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              if (newIndex >= newWorkout.getNumExercises()) {
                                newIndex -= 1;
                              }
                              newWorkout.moveExercise(oldIndex, newIndex);
                              if (newWorkout.exercises.isNotEmpty) {
                                updateWorkoutFirebase();
                              }
                            });
                          },
                          padding: EdgeInsets.all(8),
                          children: <Widget>[
                            for (int index = 0;
                                index <
                                    newWorkout
                                        .getExercisesList()
                                        .length; //use other getlength function
                                index += 1)
                              ExerciseContainer(Key('$index'), ctx, index),
                          ],
                        ),
                      ),
                      //Container for add and delete buttons
                      Container(
                          padding: EdgeInsets.only(
                              left: size.width / 8, right: size.width / 8),
                          key: Key("-1"),
                          height: size.height / 8,
                          child: Column(
                            children: [
                              Spacer(),
                              //Add new exercise button
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: foregroundGrey,
                                  ),
                                  onPressed: () {
                                    modifyExercise(
                                      ctx: ctx,
                                      name: "",
                                      changeIndex: -1,
                                      setState: setState,
                                    );
                                  },
                                  child: Center(
                                    child: Icon(Icons.add, color: accentColor),
                                  )),
                              SizedBox(
                                width: size.width / 2,
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        backgroundColor: foregroundGrey,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        )),
                                    onPressed: () {
                                      deleteConfirmPopup(
                                        'Are you sure you want to delete this exercise?',
                                        context,
                                        () {
                                          removeWorkout(context).then((value) {
                                            Navigator.of(context).pop();
                                          });
                                        },
                                      );

                                      // setState(() {
                                      //   removeWorkout(context);
                                      // });
                                    },
                                    child: Row(
                                      children: const [
                                        Spacer(),
                                        Text("Delete Workout",
                                            style:
                                                TextStyle(color: Colors.red)),
                                        Spacer(),
                                      ],
                                    )),
                              ),
                            ],
                          ) //),
                          ),
                      Spacer(),
                    ],
                  ),
                ),
              ));
    });
  }
}
