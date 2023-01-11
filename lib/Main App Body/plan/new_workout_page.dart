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
import 'package:gymchimp/Main%20App%20Body/plan/exercise_container.dart';
import 'package:gymchimp/Main%20App%20Body/workout/workout_page.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:numberpicker/numberpicker.dart';
import 'new_workout_page.dart';
import '../workout/workout.dart';
import 'package:reorderables/reorderables.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../app_bar.dart';
import 'plan_page.dart';

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
Function modExercise = () {};

class _NewWorkoutPage extends State<NewWorkoutPage> {
  int index;
  _NewWorkoutPage({required this.index});
  List<Map<String, String>> data = [];
  List<String> searchList = [];
  List<String> difficultyList = [];
  List<String> muscleList = [];

  List<String> exerciseTempList = [];
  List<String> difficultyTempList = [];
  List<String> muscleTempList = [];

  TextEditingController exerciseNameField = new TextEditingController(text: "");
  String workoutIDFirebase = "";

  @override
  void initState() {
    modExercise = modifyExercise;
    workoutIndex = index;
    newWorkout = currentUser.userWorkouts[index];
    getWorkoutID();
    readJson();
    super.initState();
  }

  void getWorkoutID() async {
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

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      List<String> dummyMuscleListData = [];
      List<String> dummyDifficultyList = [];

      searchList.forEach((element) {
        int ind = searchList.indexOf(element);
        if (element.toLowerCase().contains(query.toLowerCase()) ||
            muscleList[ind].toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(element);
          dummyMuscleListData.add(muscleList[ind]);
          dummyDifficultyList.add(difficultyList[ind]);

          setState(() {
            exerciseTempList.clear();
            muscleTempList.clear();
            difficultyTempList.clear();

            exerciseTempList.addAll(dummyListData);
            muscleTempList.addAll(dummyMuscleListData);
            difficultyTempList.addAll(dummyDifficultyList);
          });
          return;
        }
      });
    } else {
      setState(() {
        exerciseTempList.clear();
        muscleTempList.clear();
        difficultyTempList.clear();

        exerciseTempList.addAll(searchList);
        muscleTempList.addAll(muscleList);
        difficultyTempList.addAll(difficultyList);
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

  void firebaseRemoveExercise(int deleteIndex, bool removeAll) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(workoutIDFirebase)
        .collection('exercises')
        .get();

    List list = querySnapshot.docs;
    list.forEach((element) async {
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('workouts')
          .doc(workoutIDFirebase)
          .collection('exercises')
          .doc(element.id)
          .get()
          .then((value) {
        if (value.get('index') == deleteIndex) {
          firestore
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('workouts')
              .doc(workoutIDFirebase)
              .collection('exercises')
              .doc(element.id)
              .delete();
          setState(() {
            if (removeAll) {
              newWorkout.removeExercise(0);
            } else {
              newWorkout.removeExercise(deleteIndex);
            }
            if (newWorkout.exercises.isNotEmpty) {
              updateWorkoutFirebase();
            }
          });
          return;
        }
      });
    });
  }

  void removeWorkout(BuildContext ctx) async {
    int i = 0;
    while (i < newWorkout.exercises.length) {
      firebaseRemoveExercise(i, true);
      i++;
    }
    await firestore.runTransaction((Transaction myTransaction) async {
      myTransaction.delete(firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('workouts')
          .doc(newWorkout.getName()));
    });
    widget.callback(widget.index);
    Navigator.of(ctx).pop();
  }

  void updateWorkoutFirebase() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(workoutIDFirebase)
        .collection('exercises')
        .get();

    List list = querySnapshot.docs;
    int i = 0;
    for (var element in list) {
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('workouts')
          .doc(workoutIDFirebase)
          .collection('exercises')
          .doc(element.id)
          .get()
          .then((value) async {
        if (i < newWorkout.exercises.length) {
          firestore
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('workouts')
              .doc(workoutIDFirebase)
              .collection('exercises')
              .doc(element.id)
              .update({
            'index': i,
            'name': newWorkout.exercises[i],
            'reps': newWorkout.reps[i]
          });
          i++;
        } else {
          return;
        }
      });
    }
  }

  void pushExerciseToWorkoutFirebase(int indx) async {
    QuerySnapshot querySnapshot2 = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(workoutIDFirebase)
        .collection('exercises')
        .get();
    List list2 = querySnapshot2.docs;
    List list3 = [];
    list2.forEach((element) async {
      list3.add(element.id);
    });

    int i = 0;
    while (list3.contains("Exercise $i")) {
      i++;
    }

    String exerciseName = "Exercise $i";
    firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(workoutIDFirebase)
        .collection('exercises')
        .doc(exerciseName)
        .set({
      'name': newWorkout.getExercise(indx),
      'reps': newWorkout.getRepsForExercise(indx),
      'index': newWorkout.exercises.length - 1
    });
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
                                index < newWorkout.getNumExercises();
                                index += 1)
                              ExerciseContainer(Key('$index'), ctx, index),
                          ],
                        ),
                      ),
                      Container(
                          //Add Button
                          padding: EdgeInsets.only(
                              left: size.width / 8, right: size.width / 8),
                          key: Key("-1"),
                          height: size.height / 8,
                          child: Column(
                            children: [
                              Spacer(),
                              GestureDetector(
                                onLongPress:
                                    () {}, //Ensures that the plus button cannot be moved
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: foregroundGrey,
                                    ),
                                    onPressed: () {
                                      print(currentUser.getUserWorkouts[0]
                                          .getExercisesList()
                                          .toString());
                                      modifyExercise(ctx, "", -1);
                                    },
                                    child: Center(
                                      child:
                                          Icon(Icons.add, color: accentColor),
                                    )),
                              ),
                              Container(
                                width: size.width / 2,
                                child: GestureDetector(
                                  onLongPress:
                                      () {}, //Ensures that the plus button cannot be moved
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor: foregroundGrey,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          )),
                                      onPressed: () {
                                        setState(() {
                                          removeWorkout(context);
                                        });
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

/*
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
  //Modify Exercise Popup
  void modifyExercise(BuildContext ctx, String name, int changeIndex) {
    //If changeIndex is -1, we are adding a new exercise
    final GlobalKey<AnimatedListState> _listKey = GlobalKey();
    //final GlobalKey<AnimatedListState> _listKey2 =
    GlobalKey<AnimatedListState>();
    String newName = name;
    String title = changeIndex == -1 ? "New Exercise" : "Edit Exercise";
    exerciseNameField.text = name;
    List<int> reps = changeIndex == -1
        ? <int>[3]
        : newWorkout.getRepsForExercise(changeIndex);

    //sets numReps to a default 3 if making a new workout, or to the current value if modifying workout
    //int numReps = changeIndex == -1 ? 3 : newWorkout.getReps(changeIndex)[0];

    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(35),
        topRight: Radius.circular(35),
      )),
      context: ctx,
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        bool choosingExercise = true;
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(15),
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      //New/Edit Exercise Title
                      margin: EdgeInsets.all(30),
                      child: Text(title,
                          style: Theme.of(context).textTheme.headlineMedium)),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 5, right: 5),
                    //padding: const EdgeInsets.all(20),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(20.0),
                    //   boxShadow: const [
                    //     BoxShadow(
                    //         color: Color.fromARGB(36, 0, 0, 0),
                    //         offset: Offset(0.0, 5.0),
                    //         blurRadius: 15.0),
                    //     BoxShadow(
                    //         color: Color.fromARGB(36, 0, 0, 0),
                    //         offset: Offset(0.0, -5.0),
                    //         blurRadius: 10.0),
                    //   ],
                    // ),
                    child: Column(
                      children: [
                        TextField(
                          // decoration:
                          //     InputDecoration(labelText: name, fillColor: Colors.black),
                          controller: exerciseNameField,
                          onChanged: (value) {
                            setModalState(() {
                              filterSearchResults(value);
                            });
                          },
                          onTap: () {
                            setModalState(
                              () {
                                choosingExercise = true;
                              },
                            );
                          },
                          decoration: const InputDecoration(
                            labelText: "Search",
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0))),
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(seconds: 1),
                          curve: Curves.ease,
                          //live list of execises
                          height: choosingExercise ? size.height / 3.75 : 0,
                          child: ListView.builder(
                            itemCount: exerciseTempList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(exerciseTempList[index]),
                                // ignore: prefer_interpolation_to_compose_strings
                                subtitle: Text(difficultyTempList[index] +
                                    "   |   "
                                        '${muscleTempList[index]}'),
                                onTap: () {
                                  choosingExercise = false;
                                  setModalState(
                                    () {
                                      setState(() {
                                        newName = exerciseNameField.text =
                                            exerciseTempList[index];
                                      });
                                    },
                                  );
                                },
                                trailing: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {},
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    curve: Curves.ease,
                    duration: Duration(seconds: 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(36, 0, 0, 0),
                            offset: Offset(0.0, 5.0),
                            blurRadius: 15.0),
                        BoxShadow(
                            color: Color.fromARGB(36, 0, 0, 0),
                            offset: Offset(0.0, -5.0),
                            blurRadius: 10.0),
                      ],
                    ),
                    alignment: Alignment.center,
                    width: size.width - 10,
                    height: choosingExercise
                        ? size.height / 5.5
                        : size.height / 2.2297,
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          child: AnimatedList(
                            scrollDirection: Axis.vertical,
                            key: _listKey,
                            padding: EdgeInsets.all(8),
                            initialItemCount: reps.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index,
                                Animation<double> animation) {
                              return SizeTransition(
                                sizeFactor: animation,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Set " + (index + 1).toString()),
                                    NumberPicker(
                                      haptics: true,
                                      value: reps[index],
                                      minValue: 0,
                                      maxValue: 50,
                                      itemHeight: 75,
                                      itemWidth: 75,
                                      axis: Axis.horizontal,
                                      onChanged: (value) => setModalState(() {
                                        reps[index] = value;
                                      }),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border:
                                            Border.all(color: Colors.black26),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setModalState(() {
                                          if (reps.length <= 1) {
                                            return null;
                                          } else {
                                            reps.removeAt(index);
                                            _listKey.currentState!.removeItem(
                                                index, (context, animation) {
                                              return SizeTransition(
                                                  sizeFactor: animation);
                                            });
                                          }
                                        });
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                            ),
                            onPressed: () {
                              _listKey.currentState!.insertItem(reps.length,
                                  duration: const Duration(seconds: 1));
                              setModalState(() {
                                reps.add(3);
                              });
                            },
                            child: Text("Add new set")),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(25),
                    child: Row(
                      children: <Widget>[
                        Spacer(
                          flex: 3,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                padding: EdgeInsets.all(25),
                                primary: Colors.red,
                                minimumSize: Size(150, 75)),
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    title: const Text(
                                        'Are you sure you want to delete this exercise?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('No, go back'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          'Yes, delete it',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.pop(ctx);
                                          setState(() {
                                            if (changeIndex != -1) {
                                              firebaseRemoveExercise(
                                                  changeIndex, false);
                                            }
                                          });
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text("Delete")),
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

                            setState(() {
                              if (newName.isNotEmpty) {
                                setModalState(
                                  () {
                                    filterSearchResults("");
                                    exerciseNameField.text = "";
                                  },
                                );
                                Navigator.pop(context);
                                if (changeIndex == -1) {
                                  newWorkout.addExercise(newName, reps);
                                  pushExerciseToWorkoutFirebase(
                                      changeIndex == -1
                                          ? newWorkout.getNumExercises() - 1
                                          : changeIndex + 1);
                                } else {
                                  newWorkout.renameExercise(
                                      changeIndex, newName);
                                  newWorkout.setReps(changeIndex, reps);
                                }
                                updateWorkoutFirebase();
                              }
                            });
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
}

//Used for removing the shadow when re-ordering exercises
Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
  return AnimatedBuilder(
    animation: animation,
    builder: (BuildContext context, Widget? child) {
      return Material(
        color: Colors.transparent,
        child: child,
      );
    },
    child: child,
  );
}
