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

Workout test = Workout("Test Workout");
String selectedExercise = test.getExercises()[0];
List<TextEditingController> controllers = [];
int index = 0;
double multiplier = 1 / test.getExercises().length;
bool checkVal = false;

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
    test.addExercise("Bench Press", [8, 60]);
    test.addExercise("Shoulder Press", [12, 72]);
    test.addExercise("Tricep Pulldown", [8, 55]);
    test.addExercise("Situp", [8, 0]);

    test.addSetToExercise("Bench Press", [10, 100]);
    test.addSetToExercise("Shoulder Press", [10, 100]);
    test.addSetToExercise("Shoulder Press", [8, 100]);
    test.addSetToExercise("Shoulder Press", [6, 100]);
    //test.printExercises();
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
    setState(() {
      progress = multiplier * (index + 1);
    });
  }

  List<Widget> returnRows = [];
  void getRows(String exercise) {
    returnRows = [];
    controllers = [];
    for (int i = 0; i < test.exercises[exercise]!.length; i++) {
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
                child: Text(test.exercises[exercise]![i][0].toString(),
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
                      hintText: test.exercises[exercise]![i][1].toString(),
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
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Navigator(onGenerateRoute: (settings) {
      return MaterialPageRoute(
        builder: (_) => MaterialApp(
          title: 'Welcome to Flutter',
          home: Scaffold(
            appBar: MyAppBar(context, true),
            backgroundColor: Colors.transparent,
            body: Container(
              height: size.height,
              width: size.width,
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
                            color: Color.fromARGB(255, 202, 202, 202)),
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: [
                        DropdownButton2(
                          iconSize: 50,
                          isExpanded: true,
                          barrierColor: Color.fromARGB(45, 0, 0, 0),
                          hint: Text(selectedExercise, style: fontstyle(25)),
                          items: test
                              .getExercises()
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (String? value) {
                            setState(
                              () {
                                index = test.getExercises().indexOf(value!);
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
                            thumbVisibility: true,
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
                          if (index < test.getExercises().length) {
                            index++;
                            selectedExercise = test.getExercises()[index];
                            getRows(selectedExercise);
                            updateProgress();
                          }
                        });
                      }),
                      child: const Text(
                          "Confirm data and proceed to next exercise"))
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
