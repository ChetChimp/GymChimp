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
import 'package:gymchimp/Main%20App%20Body/plan/new%20workout%20page/setChooser.dart';
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
                        child: ReorderableListView.builder(
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
                          itemBuilder: (BuildContext context, int index) {
                            return ExerciseContainer(
                                Key('$index'), ctx, index, modifyExercise);
                          },
                          itemCount: newWorkout.getNumExercises(),
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
        : newWorkout.getRepsForExercise(changeIndex);

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
                              bool selected = false;
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: accentColor, width: 2)),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: ListTile(
                                    selectedTileColor: Colors.blue,
                                    selectedColor: Colors.blue,
                                    tileColor: Colors.transparent,
                                    selected: selected,
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
                              primary: Colors.red,
                              minimumSize: Size(150, 75)),
                          onPressed: () {
                            return deleteConfirmPopup(
                                'Are you sure you want to delete this exercise?',
                                context, () {
                              if (changeIndex != -1) {
                                setState(() {
                                  newWorkout.removeExercise(changeIndex);
                                });
                                firebaseRemoveExercise(
                                    changeIndex, false, setState);
                              }

                              Navigator.pop(ctx);
                            });
                          },
                          child: Text("Delete"),
                        ),
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
                                exerciseLength = newWorkout.getNumExercises();
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
}

// Widget NewWorkoutDeleteButton(BuildContext context, Function onPressed) {
//   return
// }

int exerciseLength = 0;
