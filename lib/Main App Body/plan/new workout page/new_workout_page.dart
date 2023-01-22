import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymchimp/Main%20App%20Body/plan/new%20workout%20page/exercise_container.dart';
import 'package:gymchimp/Firebase/custom_firebase_functions.dart';
import 'package:gymchimp/Main%20App%20Body/plan/new%20workout%20page/setChooser.dart';
import 'package:gymchimp/Main%20App%20Body/workout/workout_page.dart';
import 'package:gymchimp/main.dart';
import '../../../customReusableWidgets/DeleteConfirmPopup.dart';
import '../../app_bar.dart';
import '../../../objects/workout.dart';

class NewWorkoutPage extends StatefulWidget {
  final Workout workout;
  // final int index;

  const NewWorkoutPage({
    Key? key,
    required this.workout,
    // required this.index,
  }) : super(key: key);

  @override
  State<NewWorkoutPage> createState() => _NewWorkoutPage(workout: this.workout);
}

//var workoutIndex; //Do we need this? Cant we just use currentworkout.getindex everywhere?
String workoutIDFirebase = "";

// Workout newWorkout = Workout("");

class _NewWorkoutPage extends State<NewWorkoutPage> {
  // int index;
  Workout workout;

  _NewWorkoutPage({required this.workout});
  List<Map<String, String>> data = [];

  List<String> exerciseTempList = [];
  List<String> difficultyTempList = [];
  List<String> muscleTempList = [];

  List<String> searchList = [];
  List<String> difficultyList = [];
  List<String> muscleList = [];

  @override
  void initState() {
    print(workout == null);
    //workoutIndex = index;
    //newWorkout = currentUser.userWorkouts[index];
    updateWorkoutIDFromFirebase(workout);
    readJson();
    super.initState();
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

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      List<String> dummyMuscleListData = [];
      List<String> dummyDifficultyList = [];
      if (!searchList.contains(query) || !muscleList.contains(query)) {
        setState(() {
          exerciseTempList.clear();
          muscleTempList.clear();
          difficultyTempList.clear();

          exerciseTempList.add("Search Not Found");
          muscleTempList.add("");
          difficultyTempList.add("");
        });
      }
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

  Widget build(BuildContext ctx) {
    Size size = MediaQuery.of(context).size;
    return Navigator(onGenerateRoute: (settings) {
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                backgroundColor: backgroundGrey,
                appBar:
                    MyAppBar(context, true, "new_workout", workout: workout),
                body: Container(
                  child: Column(
                    children: [
                      Container(
                        height: size.height * (3.6 / 5),
                        child: ReorderableListView.builder(
                          proxyDecorator: proxyDecorator,
                          onReorder: (int oldIndex, int newIndex) {
                            setState(() {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              if (newIndex >= workout.getLength()) {
                                newIndex -= 1;
                              }
                              workout.moveExercise(oldIndex, newIndex);
                              if (workout.getLength() > 0) {
                                updateWorkoutFirebase(workout);
                              }
                            });
                          },
                          padding: EdgeInsets.all(8),
                          itemBuilder: (BuildContext context, int index) {
                            return ExerciseContainer(Key('$index'), ctx, index,
                                modifyExercise, workout);
                          },
                          itemCount: workout.getLength(),
                          // children: <Widget>[
                          // for (int index = 0;
                          //     index <
                          //         newWorkout
                          //             .getExercisesList()
                          //             .length; //use other getlength function
                          //     index += 1)
                          //   ExerciseContainer(Key('$index'), ctx, index),
                          //],
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
                                      //setState: setState,
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
                                        'Are you sure you want to delete this workout?',
                                        context,
                                        () {
                                          removeWorkoutFromFirebase(
                                                  context, workout)
                                              .then((value) {
                                            Navigator.of(context).pop();
                                          });
                                          currentUser.userWorkouts
                                              .remove(workout);
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
  /*
  ------------------------------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------------------
  */

  void modifyExercise({
    required BuildContext ctx,
    required String name,
    required int changeIndex,
    //required Function setState,
  }) {
    //If changeIndex is -1, we are adding a new exercise
    final GlobalKey<AnimatedListState> _listKey = GlobalKey();
    //final GlobalKey<AnimatedListState> _listKey2 =
    //GlobalKey<AnimatedListState>();
    String newName = name;
    String title = changeIndex == -1 ? "New Exercise" : "Edit Exercise";
    bool choosingExercise = changeIndex == -1;
    TextEditingController exerciseNameField =
        new TextEditingController(text: "");
    exerciseNameField.text = name;
    List<int> reps = changeIndex == -1
        ? <int>[8]
        : workout.getExercise(changeIndex).getReps();

    //sets numReps to a default 3 if making a new workout, or to the current value if modifying workout
    //int numReps = changeIndex == -1 ? 3 : newWorkout.getReps(changeIndex)[0];

    showModalBottomSheet<void>(
      enableDrag: false,
      backgroundColor: backgroundGrey,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(35))),
      context: ctx,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: StatefulBuilder(
              builder: (BuildContext context2, StateSetter setModalState) {
            updateState() {
              setModalState(() {});
            }

            Size size = MediaQuery.of(context).size;
            final ScrollController _animatedScrollController =
                ScrollController();

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
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
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
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: "Search",
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
                                child: Material(
                                  color: Colors.transparent,
                                  child: ListTile(
                                    enabled: exerciseTempList[index] !=
                                        "Search Not Found",
                                    selectedTileColor: Colors.blue,
                                    selectedColor: Colors.blue,
                                    tileColor: Colors.transparent,
                                    title: Text(
                                      exerciseTempList[index],
                                      style: TextStyle(color: textColor),
                                    ),
                                    // ignore: prefer_interpolation_to_compose_strings
                                    subtitle: exerciseTempList[index] !=
                                            "Search Not Found"
                                        ? Text(
                                            difficultyTempList[index] +
                                                "   |   "
                                                    '${muscleTempList[index]}',
                                            style: TextStyle(color: textColor))
                                        : Text(""),
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
                                    // trailing: IconButton(
                                    //   color: textColor,
                                    //   icon: const Icon(Icons.info_outline),
                                    //   onPressed: () {},
                                    // ),
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              padding: EdgeInsets.all(25),
                              primary: foregroundGrey,
                              minimumSize: Size(150, 75)),
                          onPressed: () {
                            return deleteConfirmPopup(
                                'Are you sure you want to delete this exercise?',
                                context, () {
                              if (changeIndex != -1) {
                                setState(() {
                                  workout.removeExercise(changeIndex);
                                });
                                removeExerciseFromWorkoutFirebase(changeIndex);
                              }

                              Navigator.pop(ctx);
                            });
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              padding: EdgeInsets.all(25),
                              primary: foregroundGrey,
                              minimumSize: Size(150, 75)),
                          onPressed: () {
                            if (currentWorkout.getName() == workout.getName()) {
                              workoutState(workout);
                            }

                            if (newName.isNotEmpty) {
                              setModalState(
                                () {
                                  filterSearchResults("");
                                  exerciseNameField.text = "";
                                },
                              );
                              Navigator.pop(context);
                              if (changeIndex == -1) {
                                workout.addExerciseByName(newName, reps);
                                pushExerciseToWorkoutFirebase(
                                    workout,
                                    changeIndex == -1
                                        ? workout.getLength() - 1
                                        : changeIndex + 1);
                              } else {
                                workout.renameExercise(changeIndex, newName);
                                workout.setRepsAtIndex(changeIndex, reps);
                              }
                              currentUser.userExerciseList.add(newName);
                              updateWorkoutFirebase(workout);
                            }
                            setState(() {});
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(color: textColor, fontSize: 20),
                          ),
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
