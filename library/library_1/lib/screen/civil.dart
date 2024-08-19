import 'package:flutter/material.dart';

class CivilPage extends StatelessWidget {
  const CivilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Civil'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text(
          'Content for Civil category',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
