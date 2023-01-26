import 'package:flutter/widgets.dart';
import 'package:gymchimp/Firebase/custom_firebase_functions.dart';
import 'package:gymchimp/objects/live_exercise.dart';

class Exercise {
  String name;
  int index;
  List<int> _reps = <int>[];
  LiveExercise? _liveInstance;
  bool live = false;

  List<int> getReps() {
    return _reps;
  }

  void setReps(List<int> reps) {
    _reps = reps;
    if (live) {
      _liveInstance!.updateTextControllers();
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

  LiveExercise? getLiveInstance() {
    return _liveInstance;
  }

  void goLive() {
    live = true;
    _liveInstance = LiveExercise(this);
  }

  List<List<double>> endLive() {
    live = false;
    List<List<double>> weightsAndReps = _liveInstance!.endLive();
    _liveInstance = null;
    return weightsAndReps;
  }
}
