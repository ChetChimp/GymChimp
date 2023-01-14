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
import 'package:gymchimp/Main%20App%20Body/workout/workout_page.dart';
import 'package:gymchimp/main.dart';
import 'package:numberpicker/numberpicker.dart';
import 'custom_firebase_functions.dart';
import 'new workout page/new_workout_page.dart';
import 'package:reorderables/reorderables.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../app_bar.dart';
import 'plan_page.dart';
import 'setChooser.dart';

void modifyExercise({
  required BuildContext ctx,
  required String name,
  required int changeIndex,
  required Function setState,
}) {
  //If changeIndex is -1, we are adding a new exercise
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  //final GlobalKey<AnimatedListState> _listKey2 =
  //GlobalKey<AnimatedListState>();
  String newName = name;
  String title = changeIndex == -1 ? "New Exercise" : "Edit Exercise";
  bool choosingExercise = changeIndex == -1;
  TextEditingController exerciseNameField = new TextEditingController(text: "");
  exerciseNameField.text = name;
  List<int> reps =
      changeIndex == -1 ? <int>[3] : newWorkout.getRepsForExercise(changeIndex);

  //sets numReps to a default 3 if making a new workout, or to the current value if modifying workout
  //int numReps = changeIndex == -1 ? 3 : newWorkout.getReps(changeIndex)[0];

  showModalBottomSheet<void>(
    backgroundColor: backgroundGrey,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(35))),
    context: ctx,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: StatefulBuilder(
            builder: (BuildContext context2, StateSetter setModalState) {
          updateState() {
            setModalState(() {});
          }

          Size size = MediaQuery.of(context).size;
          final ScrollController _animatedScrollController = ScrollController();

          return Container(
            decoration: BoxDecoration(
              color: backgroundGrey,
              borderRadius: BorderRadius.all(Radius.circular(35)),
            ),
            padding: EdgeInsets.all(15),
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //New/Edit Exercise Title
                Container(
                    margin: EdgeInsets.all(30),
                    child: Text(title,
                        style: TextStyle(color: accentColor, fontSize: 35))),
                //Exercise Chooser
                Container(
                  margin: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 5, right: 5),
                  child: Column(
                    children: [
                      TextField(
                        controller: exerciseNameField,
                        style: TextStyle(color: textColor),
                        onChanged: (value) {
                          setModalState(() {
                            filterSearchResults(value, setState);
                          });
                        },
                        onTap: () {
                          setModalState(
                            () {
                              choosingExercise = true;
                            },
                          );
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide:
                                  BorderSide(width: 2, color: accentColor)),
                          //fillColor: textColor,
                          labelText: "Search",
                          labelStyle: TextStyle(
                              color: Colors.white,
                              backgroundColor: Colors.transparent),
                          focusColor: textColor,
                          floatingLabelStyle: TextStyle(
                              color: textColor,
                              backgroundColor: Colors.transparent),
                          prefixIcon: Icon(
                            Icons.search,
                            color: accentColor,
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0))),
                        ),
                      ),
                      //Animated container for live list of exercises
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.ease,
                        //live list of execises
                        height: choosingExercise ? size.height / 3.75 : 0,
                        child: ListView.builder(
                          itemCount: exerciseTempList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: accentColor, width: 2)),
                              ),
                              child: ListTile(
                                title: Text(
                                  exerciseTempList[index],
                                  style: TextStyle(color: textColor),
                                ),
                                // ignore: prefer_interpolation_to_compose_strings
                                subtitle: Text(
                                  difficultyTempList[index] +
                                      "   |   "
                                          '${muscleTempList[index]}',
                                  style: TextStyle(color: textColor),
                                ),
                                onTap: () {
                                  setModalState(
                                    () {
                                      choosingExercise = false;
                                      newName = exerciseNameField.text =
                                          exerciseTempList[index];
                                      setState(() {});
                                    },
                                  );
                                },
                                trailing: IconButton(
                                  color: textColor,
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {},
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                //Set Choosers Gesture detector
                GestureDetector(
                  onTap: () {
                    setModalState(() {
                      choosingExercise = false;
                      //To hide keyboard
                      FocusScope.of(context).requestFocus(new FocusNode());
                    });
                  },
                  //animated container for set choosers list
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      color: foregroundGrey,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    curve: Curves.ease,
                    duration: Duration(seconds: 1),
                    height: choosingExercise
                        ? size.height / 5.5 - 50
                        : size.height / 2.2297 - 50,
                    width: size.width - 10, //-10
                    child: AnimatedList(
                      controller: _animatedScrollController,
                      scrollDirection: Axis.vertical,
                      key: _listKey,
                      padding: EdgeInsets.all(8),
                      initialItemCount: reps.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index,
                          Animation<double> animation) {
                        return SizeTransition(
                          sizeFactor: CurvedAnimation(
                              parent: animation, curve: Curves.ease),
                          child: setChooser(
                            animation: animation,
                            tempValue: -1,
                            index: index,
                            reps: reps,
                            listKey: _listKey,
                            setStateParent: updateState,
                            //removeItem: removeItem,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                //Add and Remove set buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size((size.width - 50) / 2, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (reps.length >= 4) {
                            _animatedScrollController.animateTo(
                              _animatedScrollController
                                      .position.maxScrollExtent +
                                  75,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn,
                            );
                          }

                          _listKey.currentState!.insertItem(reps.length,
                              duration: const Duration(milliseconds: 750));
                          reps.add(8);
                          setModalState(() {
                            choosingExercise = false;
                          });
                        },
                        child: Text("Add new set")),
                    VerticalDivider(
                      color: accentColor,
                      thickness: 10,
                      width: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size((size.width - 50) / 2, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                        ),
                        onPressed: () {
                          choosingExercise = false;

                          if (reps.length > 1) {
                            int index = reps.length - 1;
                            int tempRep = reps.removeAt(index);

                            _listKey.currentState!.removeItem(
                                duration: Duration(milliseconds: 750),
                                index, (context, animation) {
                              //return Container();
                              return SizeTransition(
                                sizeFactor: CurvedAnimation(
                                    parent: animation, curve: Curves.easeOut),
                                child: setChooser(
                                    animation: animation,
                                    setStateParent: () => {},
                                    reps: [],
                                    tempValue: tempRep,
                                    listKey: _listKey,
                                    index: index),
                              );
                            });

                            setModalState(() {
                              choosingExercise = false;
                            });
                          }
                        },
                        child: Text("Remove set")),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 3,
                      ),
                      NewWorkoutDeleteButton(context, () {
                        Navigator.of(context).pop();
                        Navigator.pop(ctx);
                        if (changeIndex != -1) {
                          firebaseRemoveExercise(changeIndex, false, setState);
                        }
                        setState(() {});
                      }),
                      Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            padding: EdgeInsets.all(25),
                            primary: Colors.blue,
                            minimumSize: Size(150, 75)),
                        onPressed: () {
                          if (currentWorkout.getName() ==
                              newWorkout.getName()) {
                            workoutState(newWorkout);
                          }

                          if (newName.isNotEmpty) {
                            setModalState(
                              () {
                                filterSearchResults("", setState);
                                exerciseNameField.text = "";
                              },
                            );
                            Navigator.pop(context);
                            if (changeIndex == -1) {
                              newWorkout.addExercise(newName, reps);
                              pushExerciseToWorkoutFirebase(changeIndex == -1
                                  ? newWorkout.getNumExercises() - 1
                                  : changeIndex + 1);
                            } else {
                              newWorkout.renameExercise(changeIndex, newName);
                              newWorkout.setReps(changeIndex, reps);
                            }
                            updateWorkoutFirebase();
                          }
                          setState(() {});
                        },
                        child: Text("Save"),
                      ),
                      Spacer(
                        flex: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      );
    },
  );
}
