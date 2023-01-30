import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gymchimp/Main%20App%20Body/stats/weight_point.dart';
import 'package:gymchimp/main.dart';

SideTitles get _bottomTitles => SideTitles(
      showTitles: true,
      interval: 1,
      getTitlesWidget: (value, meta) {
        String text = '';
        switch (value.toInt()) {
          case 0:
            text = 'Jan';
            break;
          case 1:
            text = 'Mar';
            break;
          case 2:
            text = 'May';
            break;
          case 3:
            text = 'Jul';
            break;
          case 4:
            text = 'Sep';
            break;
          case 5:
            text = 'Nov';
            break;
        }

        return Text(text);
      },
    );

class LineChartWidget extends StatelessWidget {
  final List<WeightPoint> points;
  const LineChartWidget(this.points, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
        titlesData: FlTitlesData(
          topTitles: AxisTitles(axisNameSize: 0),
          rightTitles: AxisTitles(axisNameSize: 0),
          bottomTitles: AxisTitles(sideTitles: _bottomTitles),
        ),
        lineBarsData: [
          LineChartBarData(
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              isCurved: true,
              dotData: FlDotData(show: true),
              color: accentColor,
              preventCurveOverShooting: true,
              barWidth: 5),
        ]));
  }
}
