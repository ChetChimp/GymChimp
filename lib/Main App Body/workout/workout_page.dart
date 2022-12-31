import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/Main%20App%20Body/workout/countdown.dart';
import 'package:gymchimp/Main%20App%20Body/workout/stopwatch.dart';
import 'package:gymchimp/main.dart';
import '../app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../plan/workout.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPage();
}

Workout currentWorkout = Workout("test workout");
String selectedExercise = "";
List<TextEditingController> controllers = [];
int index = 0;
double multiplier = 0;
bool checkVal = false;
ScrollController scrollController = ScrollController();

Color secondary = Color.fromARGB(255, 114, 211, 249);
Color primary = Color.fromARGB(255, 135, 206, 235);

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
        Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          decoration: BoxDecoration(
            color: secondary,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: [
              Spacer(),
              Container(
                padding: const EdgeInsets.all(5.0),
                child: Text((i + 1).toString(),
                    style: GoogleFonts.quicksand(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.normal)),
              ),
              Spacer(),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(currentWorkout.reps[exerciseIndex][i].toString(),
                    style: GoogleFonts.quicksand(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.normal)),
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
            backgroundColor: Color.fromARGB(255, 230, 230, 230),
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
                                      items: [
                                        Container(
                                            decoration: BoxDecoration(
                                              color: primary,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              // boxShadow: const [
                                              //   BoxShadow(
                                              //       color: Color.fromARGB(
                                              //           22, 0, 0, 0),
                                              //       offset: Offset(0.0, 1.0),
                                              //       blurRadius: 15.0),
                                              //   BoxShadow(
                                              //       color: Color.fromARGB(
                                              //           22, 0, 0, 0),
                                              //       offset: Offset(0.0, -1.0),
                                              //       blurRadius: 15.0),
                                              // ],
                                            ),
                                            margin: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: countdown()),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 10),
                                            decoration: BoxDecoration(
                                              color: primary,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              // boxShadow: const [
                                              //   BoxShadow(
                                              //       color: Color.fromARGB(
                                              //           22, 0, 0, 0),
                                              //       offset: Offset(0.0, 1.0),
                                              //       blurRadius: 15.0),
                                              //   BoxShadow(
                                              //       color: Color.fromARGB(
                                              //           22, 0, 0, 0),
                                              //       offset: Offset(0.0, -1.0),
                                              //       blurRadius: 15.0),
                                              // ],
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
                                        viewportFraction: 1,
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
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                          bottomRight: Radius.circular(8)),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //       color: Color.fromARGB(22, 0, 0, 0),
                                      //       offset: Offset(0.0, 5.0),
                                      //       blurRadius: 15.0),
                                      //   BoxShadow(
                                      //       color: Color.fromARGB(22, 0, 0, 0),
                                      //       offset: Offset(0.0, -5.0),
                                      //       blurRadius: 10.0),
                                      // ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: indicators(2, activepage),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 5, bottom: 5, left: 17, right: 17),
                              child: LinearProgressIndicator(
                                backgroundColor:
                                    Color.fromARGB(255, 131, 131, 131),
                                color: secondary,
                                minHeight: 10,
                                value: progress,
                              ),
                            ),
                            Container(
                              height: size.height / 3,
                              margin: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 20, right: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromARGB(22, 0, 0, 0),
                                      offset: Offset(0.0, 2.0),
                                      blurRadius: 15.0),
                                  BoxShadow(
                                      color: Color.fromARGB(22, 0, 0, 0),
                                      offset: Offset(0.0, -2.0),
                                      blurRadius: 10.0),
                                ],
                              ),
                              child: Column(
                                children: [
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      buttonDecoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: primary),
                                      scrollbarAlwaysShow: true,
                                      scrollbarRadius: Radius.circular(5),
                                      scrollbarThickness: 5,
                                      iconSize: 50,
                                      isExpanded: true,
                                      barrierColor: Color.fromARGB(45, 0, 0, 0),
                                      hint: Text(selectedExercise,
                                          style: GoogleFonts.quicksand(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold)),
                                      items: currentWorkout.exercises
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Text("  Set ",
                                            style: GoogleFonts.quicksand(
                                                fontSize: 28)),
                                        Spacer(),
                                        Text("Reps",
                                            style: GoogleFonts.quicksand(
                                                fontSize: 28)),
                                        Spacer(),
                                        Text("Weight ",
                                            style: GoogleFonts.quicksand(
                                                fontSize: 28)),
                                        Spacer(),
                                      ],
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
                            FloatingActionButton.extended(
                                backgroundColor: secondary,
                                heroTag: "tg1",
                                onPressed: (() {
                                  setState(() {
                                    index++;
                                    if (index <
                                        currentWorkout.getNumExercises()) {
                                      selectedExercise =
                                          currentWorkout.exercises[index];
                                      getRows(selectedExercise);
                                      updateProgress();
                                    }
                                  });
                                }),
                                label: Text(
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        color: Colors.white),
                                    "Next exercise"))
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
