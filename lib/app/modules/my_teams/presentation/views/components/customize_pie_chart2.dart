import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChartSample2State();
}

class PieChartSample2State extends State {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(),
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 0,
        centerSpaceRadius: 0,
        sections: showingSections(),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      const fontSize = 12.0;
      const radius = 70.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blueAccent,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: 16,
            title: '16%',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.green,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
              shadows: shadows,
            ),
          );
        default:
          throw Exception('Oh no');
      }
    });
  }
}
