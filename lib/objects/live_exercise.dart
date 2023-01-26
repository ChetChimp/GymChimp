import 'package:flutter/widgets.dart';
import 'package:gymchimp/Firebase/custom_firebase_functions.dart';

import 'exercise.dart';

class LiveExercise {
  Exercise exercise;

  LiveExercise(this.exercise) {
    buildTextControllers();
  }

  List<TextEditingController> weightsTextControllers = [];
  List<TextEditingController> repsTextControllers = [];

  List<List<double>> endLive() {
    List<double> actualWeights = <double>[];
    List<double> actualReps = <double>[];
    for (int i = 0; i < exercise.getReps().length; i++) {
      if (weightsTextControllers[i].text != "") {
        String actualWeightString = weightsTextControllers[i].text;
        String actualRepsString = repsTextControllers[i].text == ""
            ? exercise.getReps()[i].toString()
            : repsTextControllers[i].text;
        if (actualWeightString != "") {
          actualWeights.add(double.parse(actualWeightString));
          actualReps.add(double.parse(actualRepsString));
        }
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
    for (int i = 0; i < exercise.getReps().length; i++) {
      weightsTextControllers.add(TextEditingController());
      repsTextControllers.add(TextEditingController());
    }
  }

  void updateTextControllers() {
    int deltaReps = exercise.getReps().length - weightsTextControllers.length;
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
