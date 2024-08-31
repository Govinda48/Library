import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CategoryWiseBookCountPage extends StatelessWidget {
  const CategoryWiseBookCountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Total Books',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, int>>(
        future: _getCategoryWiseBookCount(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final categoryCounts = snapshot.data!;
            final totalBooks =
                categoryCounts.values.fold<int>(0, (sum, count) => sum + count);

            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _buildPieChartSections(categoryCounts),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                    'Total Books: $totalBooks',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  // Method to get the total number of books for each category from Firestore
  Future<Map<String, int>> _getCategoryWiseBookCount() async {
    try {
      final booksCollection = FirebaseFirestore.instance.collection('books');
      final querySnapshot = await booksCollection.get();

      final categoryCounts = <String, int>{};

      for (final doc in querySnapshot.docs) {
        final category = doc['category'] as String?;
        if (category != null) {
          if (categoryCounts.containsKey(category)) {
            categoryCounts[category] = categoryCounts[category]! + 1;
          } else {
            categoryCounts[category] = 1;
          }
        }
      }

      return categoryCounts;
    } catch (e) {
      throw Exception('Failed to get category-wise book count: $e');
    }
  }

  // Method to build pie chart sections based on category counts
  List<PieChartSectionData> _buildPieChartSections(
      Map<String, int> categoryCounts) {
    final List<Color> colors = [
      Colors.teal,
      const Color.fromARGB(255, 255, 145, 137),
      Colors.green,
      const Color.fromARGB(255, 252, 59, 255),
      Colors.purple,
      Colors.orange,
      const Color.fromARGB(255, 235, 10, 85),
      Colors.blue,
      Colors.brown,
    ];

    return categoryCounts.entries.map((entry) {
      final index = categoryCounts.keys.toList().indexOf(entry.key);
      final isTouched = false; // You can add touch interaction if needed
      final double radius =
          isTouched ? 120 : 100; // Default radius for pie sections

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: entry.value.toDouble(),
        title: '${entry.key}: ${entry.value}',
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
