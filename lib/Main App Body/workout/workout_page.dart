import 'package:flutter/material.dart';
import 'package:gymchimp/Main%20App%20Body/workout/countdown.dart';
import 'package:gymchimp/Main%20App%20Body/workout/stopwatch.dart';
import '../app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../plan/workout.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPage();
}

Workout currentWorkout = Workout("Test Workout");
String selectedExercise = "";
List<TextEditingController> controllers = [];
int index = 0;
double multiplier = 0;
bool checkVal = false;
ScrollController scrollController = ScrollController();

TextStyle fontstyle(double size) {
  return TextStyle(
      fontSize: size,
      //fontWeight: FontWeight.bold,
      color: Colors.black,
      letterSpacing: 1,
      decoration: TextDecoration.none);
}

class _WorkoutPage extends State<WorkoutPage> {
  @override
  void initState() {
    getRows(selectedExercise);
    updateProgress();
    super.initState();
  }

  int activepage = 0;
  double progress = 0;

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.blue : Colors.grey,
            shape: BoxShape.circle),
      );
    });
  }

  void updateProgress() {
    multiplier = currentWorkout.exercises.isEmpty
        ? 0
        : 1 / currentWorkout.exercises.length;
    setState(() {
      progress = multiplier * (index + 1);
    });
  }

  List<Widget> returnRows = [];
  void getRows(String exercise) {
    selectedExercise = exercise;
    returnRows = [];
    controllers = [];
    if (exercise == "") {
      return;
    }
    int exerciseIndex = currentWorkout.exercises.indexOf(exercise);

    for (int i = 0; i < currentWorkout.reps[exerciseIndex].length; i++) {
      TextEditingController? newController = TextEditingController(text: "");
      controllers.add(newController);
      returnRows.add(
        Card(
          child: Row(
            children: [
              Spacer(),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text((i + 1).toString(), style: fontstyle(20)),
              ),
              Spacer(),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(currentWorkout.reps[exerciseIndex][i].toString(),
                    style: fontstyle(20)),
              ),
              Spacer(),
              Container(
                width: 40,
                //padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: controllers[i],
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      // hintText: test.exercises[listIndex]![i].toString(),
                      //hintStyle: fontstyle(),
                    ),
                    style: fontstyle(20),
                    // When form is submitted routes to askLevel page
                    onFieldSubmitted: (value) {}),
              ),
              Spacer(),
            ],
          ),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Navigator(onGenerateRoute: (settings) {
      return MaterialPageRoute(
        builder: (_) => MaterialApp(
          title: 'Welcome to Flutter',
          home: Scaffold(
            appBar: MyAppBar(context, true),
            backgroundColor: Colors.transparent,
            body: RefreshIndicator(
              displacement: 0,
              onRefresh: (() {
                return Future.delayed(Duration(milliseconds: 1), (() {
                  setState(() {
                    getRows(currentWorkout.exercises.isEmpty
                        ? ""
                        : currentWorkout.exercises[0]);
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
                      Container(
                        child: Column(
                          children: [
                            CarouselSlider(
                              items: [
                                countdown(),
                                StopWatch(),
                              ],
                              options: CarouselOptions(
                                height: size.height / 5,
                                enableInfiniteScroll: true,
                                onPageChanged: ((index, reason) {
                                  setState(() {
                                    activepage = index;
                                  });
                                }),
                                viewportFraction: 1,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: indicators(2, activepage),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  LinearProgressIndicator(
                                    minHeight: 10,
                                    value: progress,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: size.height / 3.5,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 202, 202, 202)),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                children: [
                                  DropdownButton2(
                                    scrollbarAlwaysShow: true,
                                    scrollbarRadius: Radius.circular(5),
                                    scrollbarThickness: 5,
                                    iconSize: 50,
                                    isExpanded: true,
                                    barrierColor: Color.fromARGB(45, 0, 0, 0),
                                    hint: Text(selectedExercise,
                                        style: fontstyle(25)),
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
                                          getRows(selectedExercise);
                                          updateProgress();
                                        },
                                      );
                                    },
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Text("Set ", style: fontstyle(25)),
                                        Spacer(),
                                        Text("Reps ", style: fontstyle(25)),
                                        Spacer(),
                                        Text("Weight ", style: fontstyle(25)),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: size.height / 6,
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
                            ElevatedButton(
                                onPressed: (() {
                                  setState(() {
                                    if (index <
                                        currentWorkout.getNumExercises()) {
                                      index++;
                                      selectedExercise =
                                          currentWorkout.exercises[index];
                                      getRows(selectedExercise);
                                      updateProgress();
                                    }
                                  });
                                }),
                                child: const Text("Next exercise"))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
