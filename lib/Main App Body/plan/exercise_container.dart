import 'package:flutter/material.dart';

import '../../main.dart';
import 'new_workout_page.dart';

class ExerciseContainer extends StatefulWidget {
  final ctx;
  final ind;
  const ExerciseContainer(Key? key, this.ctx, this.ind) : super(key: key);

  @override
  State<ExerciseContainer> createState() => _ExerciseContainerState();
}

class _ExerciseContainerState extends State<ExerciseContainer> {
  bool changeHeight = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      constraints: BoxConstraints(maxHeight: size.height / 1.75),
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(2),
      key: Key('$widget.ind'),
      height: changeHeight
          ? ((size.height / 14) +
              newWorkout.getRepsForExercise(widget.ind).length *
                  (size.height / 20))
          : size.height / 14,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: foregroundGrey,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
        ),
        onPressed: () {},
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.drag_indicator, color: accentColor),
                const Spacer(),
                Container(
                    width: size.width / 2,
                    child: Text(
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      newWorkout.getExercise(widget.ind),
                    )),
                const Spacer(),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(color: Colors.transparent)),
                  child: Icon(Icons.edit, color: accentColor),
                  onPressed: () {
                    modExercise(widget.ctx,
                        '${newWorkout.getExercise(widget.ind)}', widget.ind);
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.expand_more, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      changeHeight = !changeHeight;
                    });
                  },
                ),
              ],
            ),
            if (changeHeight)
              Expanded(
                  child: ListView(
                children: <Widget>[
                  for (int i = 0;
                      i < newWorkout.getRepsForExercise(widget.ind).length;
                      i++)
                    SizedBox(
                      height: size.height / 20,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: accentColor, width: 2)),
                          // borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(children: [
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(3.0),
                            child: const Text(
                              "Set ",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              (i + 1).toString(),
                              style:
                                  TextStyle(fontSize: 20, color: accentColor),
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            "Reps:  ",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          //       Spacer(),

                          //       Spacer(),
                          // Spacer(),
                          SizedBox(
                            width: size.width / 12,
                            child: Text(
                              newWorkout.reps[widget.ind][i].toString(),
                              style:
                                  TextStyle(fontSize: 20, color: accentColor),
                            ),
                          ),
                          const Spacer(),
                        ]),
                      ),
                    )
                ],
              )),
          ],
        ),
      ),
    );
  }
}
