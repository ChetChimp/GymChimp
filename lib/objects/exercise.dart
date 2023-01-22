import 'package:flutter/widgets.dart';

class Exercise {
  String name;
  int index;
  List<int> _reps = <int>[];

  List<int> getReps() {
    return _reps;
  }

  void setReps(List<int> reps) {
    _reps = reps;
    if (live) {
      updateTextControllers();
    }
  }

  Exercise(this.name, this.index);

  Exercise.withReps(this.name, this.index, this._reps);

  String getName() {
    return name;
  }

  void setName(String name) {
    this.name = name;
  }

  int getIndex() {
    return index;
  }

  @override
  String toString() {
    return name;
  }

  //***************************************************//
  //Live Workout functions
  bool live = false;
  List<TextEditingController> exerciseTextControllers = [];

  void goLive() {
    live = true;
    buildTextControllers();
  }

  void endLive() {
    live = false;
    exerciseTextControllers = [];
  }

  void buildTextControllers() {
    for (int i = 0; i < _reps.length; i++) {
      exerciseTextControllers.add(TextEditingController());
    }
  }

  void updateTextControllers() {
    int deltaReps = _reps.length - exerciseTextControllers.length;
    while (deltaReps > 0) {
      exerciseTextControllers.add(TextEditingController());
      deltaReps--;
    }
    while (deltaReps < 0) {
      exerciseTextControllers.removeLast();
      deltaReps++;
    }
  }

  TextEditingController getController(int index) {
    return exerciseTextControllers[index];
  }
}