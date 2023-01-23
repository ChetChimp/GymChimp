import 'package:flutter/widgets.dart';
import 'package:gymchimp/Firebase/custom_firebase_functions.dart';

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

  List<TextEditingController> weightsTextControllers = [];
  List<TextEditingController> repsTextControllers = [];

  void goLive() {
    live = true;
    buildTextControllers();
  }

  List<List<double>> endLive() {
    live = false;
    List<double> actualWeights = <double>[];
    List<double> actualReps = <double>[];
    for (int i = 0; i < _reps.length; i++) {
      String actualWeightString = weightsTextControllers[i].text;
      String actualRepsString = repsTextControllers[i].text == ""
          ? _reps[i].toString()
          : repsTextControllers[i].text;
      if (actualWeightString != "") {
        actualWeights.add(double.parse(actualWeightString));
        actualReps.add(double.parse(actualRepsString));
      }
    }
    weightsTextControllers = [];
    repsTextControllers = [];

    List<List<double>> actualWeightsAndReps = <List<double>>[];
    actualWeightsAndReps.add(actualWeights);
    actualWeightsAndReps.add(actualReps);

    return actualWeightsAndReps;
  }

  void buildTextControllers() {
    for (int i = 0; i < _reps.length; i++) {
      weightsTextControllers.add(TextEditingController());
      repsTextControllers.add(TextEditingController());
    }
  }

  void updateTextControllers() {
    int deltaReps = _reps.length - weightsTextControllers.length;
    while (deltaReps > 0) {
      weightsTextControllers.add(TextEditingController());
      repsTextControllers.add(TextEditingController());
      deltaReps--;
    }
    while (deltaReps < 0) {
      weightsTextControllers.removeLast();
      repsTextControllers.removeLast();
      deltaReps++;
    }
  }

  TextEditingController getWeightsController(int index) {
    return weightsTextControllers[index];
  }

  TextEditingController getRepsController(int index) {
    return repsTextControllers[index];
  }
}
