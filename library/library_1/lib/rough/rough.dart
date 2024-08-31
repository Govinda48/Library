// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PieChartScreen(),
    );
  }
}

class PieChartScreen extends StatefulWidget {
  const PieChartScreen({super.key});

  @override
  _PieChartScreenState createState() => _PieChartScreenState();
}

class _PieChartScreenState extends State<PieChartScreen> {
  int touchedIndex = -1; // Index of the currently touched section

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pie Chart Example')),
      body: Center(
        child: PieChart(
          PieChartData(
            sectionsSpace: 4, // Space between the pie sections
            centerSpaceRadius:
                50, // Radius of the center space (makes it look like a donut chart)
            sections: _buildPieChartSections(),
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return List.generate(5, (index) {
      final isTouched = index == touchedIndex;
      final double radius = isTouched ? 120 : 100; // Increase radius if touched
      final Color color = [
        Colors.blue,
        Colors.red,
        Colors.green,
        Colors.yellow,
        Colors.purple
      ][index];

      return PieChartSectionData(
        color: color,
        value: [25, 20, 15, 30, 10][index].toDouble(),
        title: '${colorToString(color)} ${[25, 20, 15, 30, 10][index]}%',
        radius: radius,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        badgeWidget: isTouched
            ? Container(
                width: 2, // Set a shadow effect with black color
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // Shadow effect
                  shape: BoxShape.circle,
                ),
              )
            : null,
        badgePositionPercentageOffset: isTouched ? 1.3 : 0.0,
      );
    });
  }

  String colorToString(Color color) {
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.red) return 'Red';
    if (color == Colors.green) return 'Green';
    if (color == Colors.yellow) return 'Yellow';
    return 'Purple';
  }
}
