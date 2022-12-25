import 'dart:collection';

class Workout {
  var name;
  var numberOfExercises = 0;
  Map exercises = <String, List<List<int>>>{};

  Workout(this.name);

  void addExercise(String name, List<int> repsWeight) {
    List<List<int>> listOfRepsWeight = [];
    listOfRepsWeight.add(repsWeight);
    exercises[name] = listOfRepsWeight;
    numberOfExercises++;
  }

  void addSetToExercise(String name, List<int> repsWeight) {
    exercises[name].add(repsWeight);
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
      print('*=======================*');
    });
  }

  String getName() {
    return name;
  }

  int getNumExercises() {
    return numberOfExercises;
  }

  List getExercises() {
    return exercises.keys.toList();
  }
}
