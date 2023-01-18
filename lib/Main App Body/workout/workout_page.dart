import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/Main%20App%20Body/home_page.dart';
import 'package:gymchimp/Main%20App%20Body/workout/countdown.dart';
import 'package:gymchimp/Main%20App%20Body/workout/stopwatch.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/objects/exercise.dart';
import '../app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import '../../objects/workout.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPage();
}

Function workoutState = () {};
Function unitState = () {};
Function dropdownUpdate = () {};

Workout currentWorkout = Workout("Select Workout");
String selectedExercise = "";
List<TextEditingController> controllers = [];
int index = 0;
double multiplier = 0;
bool checkVal = false;
ScrollController scrollController = ScrollController();
Radius radius = Radius.circular(20);
bool unit = true;
List<Exercise> exerciseList = [];

TextStyle fontstyle(double size) {
  return TextStyle(
      fontSize: size,
      //fontWeight: FontWeight.bold,
      color: Colors.black,
      letterSpacing: 1,
      decoration: TextDecoration.none);
}

class _WorkoutPage extends State<WorkoutPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    fillExerciseList(currentWorkout);
    getRows();
    updateProgress();
    workoutState = setWorkout;
    unitState = setUnit;
    dropdownUpdate = updateDropdown;
    super.initState();
  }

  void fillExerciseList(Workout w) {
    for (int i = 0; i < w.exercises.length; i++) {
      setState(() {
        exerciseList.add(Exercise(w.exercises[i], i));
        updateDropdown();
      });
    }
  }

  void setWorkout(Workout w) {
    setState(() {
      currentWorkout = w;
      index = 0;
      exerciseList = [];
      fillExerciseList(w);
      selectedExercise = exerciseList.isEmpty ? "" : exerciseList[0].getName();
      getRows();
      updateProgress();
    });
  }

  void setUnit(bool w) {
    setState(() {
      unit = w;
    });
    getRows();
  }

  void updateDropdown() {
    dropdownListUpdate();
  }

  int activepage = 0;
  double progress = 0;
  CarouselController carouselController = CarouselController();

  List<Widget> indicators(currentIndex) {
    return List<Widget>.generate(2, (index) {
      if (index == 0) {
        return Container(
          // margin: EdgeInsets.only(left: 5, right: 5),
          child: IconButton(
            splashRadius: 1,
            onPressed: () {
              carouselController.animateToPage(0);
              setState(() {
                indicators(0);
              });
            },
            icon: Icon(
              Icons.schedule,
              color: currentIndex == index ? Colors.white : Colors.grey,
            ),
          ),
        );
      } else if (index == 1) {
        return Container(
          // margin: EdgeInsets.only(left: 5, right: 5),
          child: IconButton(
            splashRadius: 1,
            onPressed: () {
              carouselController.animateToPage(1);
              setState(() {
                indicators(1);
              });
            },
            icon: Icon(
              Icons.timer,
              color: currentIndex == index ? Colors.white : Colors.grey,
            ),
          ),
        );
      } else {
        return Icon(
          Icons.schedule,
          color: currentIndex == index ? Colors.white : Colors.grey,
        );
      }
    });
  }

  void updateProgress() {
    setState(() {
      multiplier = currentWorkout.exercises.isEmpty
          ? 0
          : 1 / currentWorkout.exercises.length;
      progress = multiplier * (index + 1);
    });
  }

  List<Widget> returnRows = [];
  void getRows() {
    returnRows = [];
    controllers = [];
    if (selectedExercise == "") {
      return;
    }
    int exerciseIndex = index;

    for (int i = 0; i < currentWorkout.reps[exerciseIndex].length; i++) {
      TextEditingController? newController = TextEditingController(text: "");
      controllers.add(newController);
      returnRows.add(
        Container(
          margin: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //     colors: secondary,
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight),
            border: Border(bottom: BorderSide(color: accentColor, width: 2)),
            // borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              Text(
                "Reps:  ",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              Text(
                currentWorkout.reps[exerciseIndex][i].toString(),
                style: TextStyle(fontSize: 24, color: accentColor),
              ),
              Spacer(
                flex: 2,
              ),
              Container(
                decoration: BoxDecoration(
                  color: backgroundGrey,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                width: 40,
                //padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: controllers[i],
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      // hintText: test.exercises[listIndex]![i].toString(),
                      //hintStyle: fontstyle(),
                    ),
                    style: fontstyle(20),
                    // When form is submitted routes to askLevel page
                    onFieldSubmitted: (value) {}),
              ),
              Text(
                unit ? " Lbs" : " Kgs",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              Spacer(),
            ],
          ),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    int lateIndex = index;
    bool nextOnTop = false;
    void updateLateIndex(bool bool) {
      int tempIndex = index;
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          nextOnTop = bool;
          lateIndex = tempIndex;
        });
      });
    }

    GlobalKey nextKey = GlobalKey();

    GlobalKey previousKey = GlobalKey();
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Navigator(onGenerateRoute: (settings) {
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: MyAppBar(context, true, "workout_page"),
          backgroundColor: backgroundGrey,
          body: RefreshIndicator(
            displacement: 0,
            onRefresh: (() {
              return Future.delayed(Duration(milliseconds: 1), (() {
                setState(() {
                  fillExerciseList(currentWorkout);
                  getRows();
                  index = 0;
                  updateProgress();
                });
              }));
            }),
            child: Container(
              height: size.height,
              width: size.width,
              child: Scrollbar(
                child: ListView(
                  children: [
                    //Container(
                    Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: size.height / 3.5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(0, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: CarouselSlider(
                                  carouselController: carouselController,
                                  items: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: foregroundGrey,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          // boxShadow: shadow
                                        ),
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: countdown()),
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          color: foregroundGrey,
                                          // gradient: LinearGradient(
                                          //     colors: primaryGradient),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: StopWatch()),
                                  ],
                                  options: CarouselOptions(
                                    height: size.height / 4,
                                    enableInfiniteScroll: false,
                                    onPageChanged: ((index, reason) {
                                      setState(() {
                                        activepage = index;
                                      });
                                    }),
                                    viewportFraction: .92,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: size.width / 2 - (size.width / 8),
                              top: size.height / 4.55,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                width: size.width / 4,
                                decoration: const BoxDecoration(
                                  // color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: indicators(activepage),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 5, bottom: 5, left: 17, right: 17),
                          child: GradientProgressIndicator(
                            gradient: LinearGradient(
                                colors: [foregroundGrey, accentColor]),
                            value: progress,
                          ),
                        ),
                        Container(
                          height: size.height / 3,
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: foregroundGrey,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: [
                              AnimatedContainer(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
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
                                          radius = Radius.circular(20);
                                        });
                                      }
                                    },
                                    buttonHeight: size.height / 14,
                                    scrollbarAlwaysShow: true,
                                    scrollbarRadius: Radius.circular(5),
                                    scrollbarThickness: 5,
                                    iconSize: 50,
                                    dropdownMaxHeight: size.height / 3,
                                    iconEnabledColor: foregroundGrey,
                                    isExpanded: true,
                                    barrierColor: Color.fromARGB(45, 0, 0, 0),
                                    hint: Text(selectedExercise,
                                        style: TextStyle(
                                            color: foregroundGrey,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w500)),
                                    items: currentWorkout.exercises
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (String? value) {
                                      setState(
                                        () {
                                          index = currentWorkout.exercises
                                              .indexOf(value!);
                                          selectedExercise = value;
                                          getRows();
                                          updateProgress();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                height: size.height / 5,
                                child: Scrollbar(
                                  //thumbVisibility: true,
                                  child: ListView(
                                    //physics: BouncingScrollPhysics(),
                                    children: returnRows,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height / 75),

                        GestureDetector(
                          onTapDown: (details) {
                            var position = details.globalPosition;
                            if (nextKey.currentContext != null) {
                              var box = nextKey.currentContext
                                  ?.findRenderObject() as RenderBox;
                              var position2 = box.localToGlobal(Offset.zero);
                              var x1 = position.dx;
                              var y1 = position.dy;
                              var x2 = position2.dx + size.width / 6;
                              var y2 = position2.dy + size.height / 40;
                              if (sqrt(pow(x2 - x1, 2) + 8 * pow(y2 - y1, 2)) <
                                  75) {
                                setState(() {
                                  if (index <
                                      currentWorkout.getNumExercises() - 1) {
                                    index++;
                                    updateLateIndex(true);
                                    selectedExercise =
                                        currentWorkout.exercises[index];
                                    getRows();
                                    updateProgress();
                                  }
                                });
                              }
                            }
                            if (previousKey.currentContext != null) {
                              var box = previousKey.currentContext
                                  ?.findRenderObject() as RenderBox;
                              var position2 = box.localToGlobal(Offset.zero);
                              var x1 = position.dx;
                              var y1 = position.dy;
                              var x2 = position2.dx + size.width / 6;
                              var y2 = position2.dy + size.height / 40;
                              if (sqrt(pow(x2 - x1, 2) + 8 * pow(y2 - y1, 2)) <
                                  75) {
                                setState(() {
                                  if (index > 0) {
                                    index--;
                                    updateLateIndex(false);
                                    selectedExercise =
                                        currentWorkout.exercises[index];
                                    getRows();
                                    updateProgress();
                                  }
                                });
                              }
                            }
                          },
                          child: SizedBox(
                            width: size.width,
                            height: size.height / 10,
                            child: Stack(
                              children: <Widget>[
                                AnimatedContainer(
                                  curve: Curves.ease,
                                  width: size.width,
                                  height: size.height / 10,
                                  color: Colors.transparent,
                                  alignment: index ==
                                              currentWorkout.getNumExercises() -
                                                  1 ||
                                          index <= 0
                                      ? Alignment.center
                                      : Alignment(1.5, 0),
                                  duration: Duration(milliseconds: 500),
                                  padding: EdgeInsets.only(
                                      left: size.width / 5,
                                      right: size.width / 5),
                                  child: Visibility(
                                    //maintainInteractivity: false,
                                    visible: nextOnTop &&
                                        (lateIndex <
                                                currentWorkout
                                                        .getNumExercises() -
                                                    1 ||
                                            index <
                                                currentWorkout
                                                        .getNumExercises() -
                                                    1),
                                    child: MaterialButton(
                                      key: nextKey,
                                      disabledColor: foregroundGrey,
                                      color: foregroundGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      height: size.height / 20,
                                      minWidth: size.width / 3,
                                      onPressed: null,
                                      child: Text(
                                        style: TextStyle(
                                            fontSize: 26, color: accentColor),
                                        "Next",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  curve: Curves.ease,
                                  width: size.width,
                                  height: size.height / 10,
                                  color: Colors.transparent,
                                  alignment: index ==
                                              currentWorkout.getNumExercises() -
                                                  1 ||
                                          index <= 0
                                      ? Alignment.center
                                      : Alignment(-1.5, 0),
                                  duration: Duration(milliseconds: 500),
                                  padding: EdgeInsets.only(
                                      left: size.width / 5,
                                      right: size.width / 5),
                                  child: Visibility(
                                    //maintainInteractivity: false,
                                    visible: lateIndex > 0 || index > 0,
                                    child: MaterialButton(
                                      key: previousKey,
                                      disabledColor: foregroundGrey,
                                      color: foregroundGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      height: size.height / 20,
                                      minWidth: size.width / 3,
                                      onPressed: null,
                                      child: Text(
                                        style: TextStyle(
                                            fontSize: 26, color: accentColor),
                                        "Previous",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  curve: Curves.ease,
                                  width: size.width,
                                  height: size.height / 10,
                                  color: Colors.transparent,
                                  alignment: index ==
                                              currentWorkout.getNumExercises() -
                                                  1 ||
                                          index <= 0
                                      ? Alignment.center
                                      : Alignment(1.5, 0),
                                  duration: Duration(milliseconds: 500),
                                  padding: EdgeInsets.only(
                                      left: size.width / 5,
                                      right: size.width / 5),
                                  child: Visibility(
                                    //maintainInteractivity: false,
                                    visible: !nextOnTop &&
                                        (lateIndex <
                                                currentWorkout
                                                        .getNumExercises() -
                                                    1 ||
                                            index <
                                                currentWorkout
                                                        .getNumExercises() -
                                                    1),
                                    child: MaterialButton(
                                      key: nextKey,
                                      disabledColor: foregroundGrey,
                                      color: foregroundGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      height: size.height / 20,
                                      minWidth: size.width / 3,
                                      onPressed: null,
                                      child: Text(
                                        style: TextStyle(
                                            fontSize: 26, color: accentColor),
                                        "Next",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
