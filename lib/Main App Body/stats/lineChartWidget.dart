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
List<ChartData> repData = [];

late ZoomPanBehavior zoomPanBehavior;
late TooltipBehavior _tooltipBehavior;

Function findExerciseDataConnect = () {};

class _LineChartWidgetState extends State<LineChartWidget> {
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);

    zoomPanBehavior = ZoomPanBehavior(
        enablePanning: true,
        enablePinching: true,
        enableMouseWheelZooming: true,
        enableSelectionZooming: true,
        enableDoubleTapZooming: true);

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
          List reps = value.get('reps');
          List weights = value.get('weights');
          double weightAverage = 0;
          weights.forEach((element) {
            weightAverage += element;
          });
          double repAverage = 0;
          reps.forEach(
            (element) {
              repAverage += element;
            },
          );
          weightAverage /= weights.length;
          repAverage /= reps.length;
          var t = value.get('timestamp');
          setState(() {
            repData.add(ChartData(t.toDate(), repAverage));
            repData.sort((a, b) {
              return a.x.compareTo(b.x);
            });
            chartData.add(ChartData(t.toDate(), weightAverage));
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
        backgroundColor: backgroundGrey,
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Container(
                margin: EdgeInsets.only(right: 10),
                child: SfCartesianChart(
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.top,
                      textStyle: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    tooltipBehavior: _tooltipBehavior,
                    primaryXAxis: DateTimeAxis(
                      borderColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    primaryYAxis: NumericAxis(
                        title: AxisTitle(
                            text: "Weight",
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 14)),
                    title: ChartTitle(
                        text: selectedExerciseName.isEmpty
                            ? "Select An Exercise"
                            : selectedExerciseName,
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 18)),
                    plotAreaBackgroundColor: foregroundGrey,
                    plotAreaBorderColor: Colors.transparent,
                    backgroundColor: backgroundGrey,
                    palette: [Colors.blue, Colors.red],
                    zoomPanBehavior: zoomPanBehavior,
                    series: <ChartSeries<ChartData, DateTime>>[
                      LineSeries<ChartData, DateTime>(
                          name: "Reps",
                          dataSource: repData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y),
                      LineSeries<ChartData, DateTime>(
                          name: "Weight",
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
