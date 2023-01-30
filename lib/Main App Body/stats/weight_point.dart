import 'package:collection/collection.dart';

class WeightPoint {
  final double x;
  final double y;
  WeightPoint({required this.x, required this.y});

  List<WeightPoint> get weightPoints {
    final data = <double>[2, 4, 6, 11, 3, 6];
    return data
        .mapIndexed(
            (index, element) => WeightPoint(x: index.toDouble(), y: element))
        .toList();
  }
}
