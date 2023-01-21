import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/Main%20App%20Body/home_page.dart';
import 'package:gymchimp/Main%20App%20Body/workout/countdown.dart';
import 'package:gymchimp/Main%20App%20Body/workout/main_carousel.dart';
import 'package:gymchimp/Main%20App%20Body/workout/next_previous_done_button.dart';
import 'package:gymchimp/Main%20App%20Body/workout/stopwatch.dart';
import 'package:gymchimp/Main%20App%20Body/workout/workoutSummaryPopup.dart';
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

int index = 0;
double multiplier = 0;
bool checkVal = false;
ScrollController scrollController = ScrollController();
Radius radius = const Radius.circular(20);
bool unit = true;
List<Exercise> exerciseList = [];
double progress = 0;

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

  //String selectedExerciseName = "";

  void fillExerciseList(Workout w) {
    for (int i = 0; i < w.getLength(); i++) {
      setState(() {
        exerciseList.add(w.getExercise(i));
        updateDropdown();
      });
    }
  }

  void setWorkout(Workout w) {
    //reset workoutTextControllers
    w.goLive();
    currentWorkout.endLive;

    setState(() {
      currentWorkout = w;
      index = 0;
      exerciseList = [];
      fillExerciseList(w);
      // selectedExerciseName =
      //     exerciseList.isEmpty ? "" : exerciseList[0].getName();
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

  void updateProgress() {
    setState(() {
      multiplier =
          currentWorkout.getLength() == 0 ? 0 : 1 / currentWorkout.getLength();
      progress = multiplier * (index + 1);
    });
  }

  List<Widget> returnRows = [];
  void getRows() {
    returnRows = [];
    //controllers = [];
    if (currentWorkout.getLength() == 0) {
      return;
    }
    int exerciseIndex = index;

    for (int i = 0;
        i < currentWorkout.getRepsForExercise(exerciseIndex).length;
        i++) {
      //TextEditingController? newController = TextEditingController(text: "");
      //controllers.add(newController);
      returnRows.add(
        Container(
          margin: const EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: accentColor, width: 2)),
          ),
          child: Row(
            children: [
              const Text(
                "Reps:  ",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              Text(
                currentWorkout.getRepsForExercise(exerciseIndex)[i].toString(),
                style: TextStyle(fontSize: 24, color: accentColor),
              ),
              const Spacer(
                flex: 2,
              ),
              Container(
                decoration: BoxDecoration(
                  color: backgroundGrey,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                width: 40,
                //padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller:
                        currentWorkout.getExercise(index).getController(i),
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
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey nextKey = GlobalKey();
    GlobalKey previousKey = GlobalKey();
    GlobalKey doneKey = GlobalKey();
    bool nextOnTop = true;
    Size size = MediaQuery.of(context).size;

    super.build(context);

    return Navigator(onGenerateRoute: (settings) {
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: MyAppBar(context, true, "workout_page"),
          backgroundColor: backgroundGrey,
          body: RefreshIndicator(
            displacement: 0,
            onRefresh: (() {
              return Future.delayed(const Duration(milliseconds: 1), (() {
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
              //list view for swipe down to refresh
              child: ListView(
                children: [
                  //main column for workout page
                  Column(
                    children: [
                      //stack for carousel + hints
                      MainCarousel(
                        size: size,
                        carouselController: CarouselController(),
                        setState: setState,
                      ),
                      //Progress bar
                      Container(
                        margin: const EdgeInsets.only(
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
                                    topLeft: const Radius.circular(20),
                                    topRight: const Radius.circular(20),
                                    bottomLeft: radius,
                                    bottomRight: radius),
                                color: accentColor,
                              ),
                              duration: const Duration(milliseconds: 200),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<Exercise>(
                                  onMenuStateChange: (isOpen) {
                                    if (isOpen) {
                                      setState(() {
                                        radius = const Radius.circular(0);
                                      });
                                    } else {
                                      setState(() {
                                        radius = const Radius.circular(20);
                                      });
                                    }
                                  },
                                  buttonHeight: size.height / 14,
                                  scrollbarAlwaysShow: true,
                                  scrollbarRadius: const Radius.circular(5),
                                  scrollbarThickness: 5,
                                  iconSize: 50,
                                  dropdownMaxHeight: size.height / 3,
                                  iconEnabledColor: foregroundGrey,
                                  isExpanded: true,
                                  barrierColor:
                                      const Color.fromARGB(45, 0, 0, 0),
                                  hint: Text(
                                      currentWorkout.getLength() > 0
                                          ? currentWorkout
                                              .getExercise(index)
                                              .getName()
                                          : "",
                                      style: TextStyle(
                                          color: foregroundGrey,
                                          fontSize: 21,
                                          fontWeight: FontWeight.w500)),
                                  items: exerciseList
                                      .map((item) => DropdownMenuItem<Exercise>(
                                            value: item,
                                            child: Text(
                                              item.getName(),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (Exercise? value) {
                                    setState(
                                      () {
                                        index = value!.getIndex();
                                        // selectedExerciseName = value.getName();
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
                      //next + previous + done buttons
                      GestureDetector(
                        onTapDown: (details) {
                          var position = details.globalPosition;
                          nextOnTop = index <= 1;
                          bool nextHasNotBeenClicked = true;

                          void pressButton(GlobalKey<State<StatefulWidget>> key,
                              String button) {
                            var box = key.currentContext?.findRenderObject()
                                as RenderBox;
                            var position2 = box.localToGlobal(Offset.zero);
                            var x1 = position.dx;
                            var y1 = position.dy;
                            var x2 = position2.dx + size.width / 6;
                            var y2 = position2.dy + size.height / 40;
                            var dist =
                                sqrt(pow(x2 - x1, 2) + 8 * pow(y2 - y1, 2));

                            if (dist < 75) {
                              if (button == "Next" || button == "Previous") {
                                setState(() {
                                  if (button == "Next") {
                                    nextHasNotBeenClicked = false;
                                  }
                                  index += (button == "Next" ? 1 : -1);
                                  // selectedExerciseName =
                                  //     currentWorkout.exercises[index].getName();
                                  getRows();
                                  updateProgress();
                                });
                              } else {
                                workoutSummary(ctx: context);
                              }
                            }
                          }

                          if (index < currentWorkout.getLength() - 1 &&
                              nextKey.currentContext != null) {
                            pressButton(nextKey, "Next");
                          }
                          if (index > 0 &&
                              nextHasNotBeenClicked &&
                              previousKey.currentContext != null) {
                            pressButton(previousKey, "Previous");
                          }
                          if (index == currentWorkout.getLength() - 1 &&
                              nextHasNotBeenClicked &&
                              doneKey.currentContext != null) {
                            pressButton(doneKey, "Done");
                          }
                        },
                        child: SizedBox(
                          width: size.width,
                          height: size.height / 10,
                          child: Stack(
                            children: <Widget>[
                              NextPreviousDoneButton(
                                size: size,
                                buttonKey: doneKey,
                                buttonText: "Done",
                              ),
                              NextPreviousDoneButton(
                                size: size,
                                buttonKey: nextKey,
                                buttonText: "Next",
                                nextOnTop: nextOnTop,
                                next1: false,
                              ),
                              NextPreviousDoneButton(
                                size: size,
                                buttonKey: previousKey,
                                buttonText: "Previous",
                              ),
                              NextPreviousDoneButton(
                                size: size,
                                buttonKey: nextKey,
                                buttonText: "Next",
                                nextOnTop: nextOnTop,
                                next1: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
