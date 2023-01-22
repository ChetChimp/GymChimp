import 'package:flutter/material.dart';
import 'package:gymchimp/objects/workout.dart';

import '../../../main.dart';
import 'new_workout_page.dart';

//Container for each exercise in new workout page
class ExerciseContainer extends StatefulWidget {
  final ctx;
  final ind;
  final newWorkout;
  final modifyExercise;
  const ExerciseContainer(
      Key? key, this.ctx, this.ind, this.modifyExercise, this.newWorkout)
      : super(key: key);

  @override
  State<ExerciseContainer> createState() =>
      _ExerciseContainerState(modifyExercise, newWorkout);
}

class _ExerciseContainerState extends State<ExerciseContainer> {
  bool changeHeight = false;
  late String _title;
  Workout newWorkout;

  Function modifyExercise;
  _ExerciseContainerState(this.modifyExercise, this.newWorkout);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      constraints: BoxConstraints(maxHeight: (size.height + 15) / 1.75),
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(2),
      key: Key('$widget.ind'),
      height: changeHeight
          ? ((size.height / 16) +
              15 +
              newWorkout.getExercise(widget.ind).getReps().length *
                  (size.height / 20))
          : size.height / 16,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: foregroundGrey,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
        ),
        onPressed: () {
          setState(() {
            changeHeight = !changeHeight;
          });
        },
        child: Column(
          children: [
            Row(
              // crossAxisAlignment: changeHeight
              //     ? CrossAxisAlignment.center
              //     : CrossAxisAlignment.start,
              children: [
                Icon(Icons.drag_indicator, color: accentColor),
                Container(
                    width: size.width / 2,
                    child: Text(
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      newWorkout.getExercise(widget.ind).getName(),
                    )),
                const Spacer(),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(color: Colors.transparent)),
                  child: Icon(Icons.edit, color: accentColor),
                  onPressed: () {
                    modifyExercise(
                      ctx: widget.ctx,
                      name: '${newWorkout.getExercise(widget.ind)}',
                      changeIndex: widget.ind,
                    );
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
                      i < newWorkout.getExercise(widget.ind).getReps().length;
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
                          SizedBox(
                            width: size.width / 12,
                            child: Text(
                              newWorkout
                                  .getExercise(widget.ind)
                                  .getReps()[i]
                                  .toString(),
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
