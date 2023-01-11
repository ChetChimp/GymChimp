import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../main.dart';
import 'new_workout_page.dart';

class ExerciseContainer extends StatefulWidget {
  final ctx;
  final ind;
  ExerciseContainer(Key? key, this.ctx, this.ind) : super(key: key);

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
      duration: Duration(milliseconds: 250),
      padding: EdgeInsets.all(2),
      key: Key('$widget.ind'),
      height: changeHeight
          ? ((size.height / 16) +
              newWorkout.getRepsForExercise(widget.ind).length *
                  (size.height / 20))
          : size.height / 16,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: foregroundGrey,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
        ),
        onPressed: () {},
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.drag_indicator, color: accentColor),
                Spacer(),
                Container(
                    width: size.width / 3,
                    child: Text(
                      style: TextStyle(color: Colors.white),
                      newWorkout.getExercise(widget.ind),
                    )),
                Spacer(),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: BorderSide(color: Colors.transparent)),
                  child: Icon(Icons.edit, color: accentColor),
                  onPressed: () {
                    modExercise(widget.ctx,
                        '${newWorkout.getExercise(widget.ind)}', widget.ind);
                  },
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.expand_more, color: Colors.white),
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
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
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
                          Spacer(),
                          Container(
                            child: Text(
                              "Reps:  ",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          //       Spacer(),

                          //       Spacer(),
                          // Spacer(),
                          Container(
                            width: size.width / 12,
                            child: Text(
                              newWorkout.reps[widget.ind][i].toString(),
                              style:
                                  TextStyle(fontSize: 20, color: accentColor),
                            ),
                          ),
                          Spacer(),
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
