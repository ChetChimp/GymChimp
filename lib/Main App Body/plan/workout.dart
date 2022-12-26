import 'dart:collection';

class Workout {
  var name;
  var numberOfExercises = 0;
  Map<String, List<List<int>>> exercises = <String, List<List<int>>>{};

  Workout(this.name);

  void addExercise(String name, List<int> repsWeight) {
    List<List<int>> listOfRepsWeight = [];
    listOfRepsWeight.add(repsWeight);
    exercises[name] = listOfRepsWeight;
    numberOfExercises++;
  }

  void addSetToExercise(String name, List<int> repsWeight) {
    exercises[name]?.add(repsWeight);
  }

  void removeExercise(String name) {
    exercises.remove(name);
  }

  void printExercises() {
    exercises.forEach((key, value) {
      print(key);
      print("-----------------------");
      value.map((list) {
        print("Reps: " +
            list[0].toString() +
            " || " +
            "Weight: " +
            list[1].toString());
      }).toList();
      print('=======================');
    });
  }

  void setExerciseName(String exercise, String newName) {
    List<int> repsWeight = getRepsWeight(exercise)![0];
    removeExercise(exercise);
    addExercise(newName, repsWeight);
  }

  String getName() {
    return name;
  }

  int getNumExercises() {
    return numberOfExercises;
  }

  List<List<int>>? getRepsWeight(String exercise) {
    return exercises[exercise];
  }

  int getSetOfExercise(String exercise) {
    return exercises[exercise]![0][0];
  }

  List<String> getExercises() {
    return exercises.keys.toList();
  }

  Map<String, List<List<int>>> getWorkout() {
    return exercises;
  }

  // setWorkout(Map<String, List<List<int>>> exercises) {
  //   this.exercises = exercises;
  // }
}
