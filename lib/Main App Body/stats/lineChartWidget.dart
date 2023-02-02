import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gymchimp/Main%20App%20Body/stats/search_exercise_widget.dart';
import 'package:gymchimp/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartWidget extends StatefulWidget {
  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

List<ChartData> chartData = [];
late ZoomPanBehavior _zoomPanBehavior;
Function findExerciseDataConnect = () {};

class _LineChartWidgetState extends State<LineChartWidget> {
  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(enablePanning: true);

    findExerciseDataConnect = findExerciseData;
    super.initState();
  }

  void findExerciseData(String input) async {
    setState(() {
      chartData = [];
    });

    firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('stats')
        .doc(input)
        .collection('history')
        .orderBy('timeStamp', descending: true);

    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('stats')
        .doc(input)
        .collection('history')
        .get();

    List list = querySnapshot.docs;
    list.forEach((element) async {
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('stats')
          .doc(input)
          .collection('history')
          .doc(element.id)
          .get()
          .then(
        (value) {
          List weights = value.get('weights');
          double avg = 0;
          weights.forEach((element) {
            avg += element;
          });
          avg /= weights.length;
          var t = value.get('timestamp');
          setState(() {
            chartData.add(ChartData(t.toDate(), avg));
            chartData.sort((a, b) {
              return a.x.compareTo(b.x);
            });
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(
                    title: ChartTitle(
                        text: selectedExerciseName,
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 18)),
                    plotAreaBackgroundColor: foregroundGrey,
                    plotAreaBorderColor: Colors.transparent,
                    backgroundColor: backgroundGrey,
                    palette: [accentColor],
                    enableAxisAnimation: true,
                    zoomPanBehavior: _zoomPanBehavior,
                    primaryXAxis: DateTimeAxis(),
                    series: <ChartSeries<ChartData, DateTime>>[
                      // Renders line chart
                      LineSeries<ChartData, DateTime>(
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y)
                    ]))));
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
