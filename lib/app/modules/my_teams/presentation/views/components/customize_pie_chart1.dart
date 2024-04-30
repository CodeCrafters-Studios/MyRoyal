import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:iroyal/base/design/colors.dart';

class PieChartSample1 extends StatefulWidget {
  const PieChartSample1({
    super.key,
    required this.titleSection1,
    required this.titleSection2,
    required this.valueSection1,
    required this.valueSection2,
  });

  final String titleSection1;
  final String titleSection2;
  final double valueSection1;
  final double valueSection2;

  @override
  State<StatefulWidget> createState() => PieChart1State();
}

class PieChart1State extends State<PieChartSample1> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(
                    widget.titleSection1,
                    widget.titleSection2,
                    widget.valueSection1,
                    widget.valueSection2,
                  ),
                ),
              ),
            ),
          ),
        ]);
  }

  List<PieChartSectionData> showingSections(String titleSection1,
      String titleSection2, double valueSection1, double valueSection2) {
    return List.generate(2, (i) {
      const fontSize = 12.0;
      const radius = 25.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: valueSection1,
            title: titleSection1,
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.purple,
            value: valueSection2,
            title: titleSection2,
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
