import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomizePieChart extends StatefulWidget {
  const CustomizePieChart({super.key, required this.sections});

  final List<PieChartSectionData> sections;

  @override
  State<StatefulWidget> createState() => _CustomizePieChartState();
}

class _CustomizePieChartState extends State<CustomizePieChart> {
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
        sections: widget.sections,
      ),
    );
  }
}
