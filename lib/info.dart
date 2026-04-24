import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info"),
        backgroundColor: Colors.indigo,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          "Welcome to the Student Grade Estimator!\n\n"
          "How to use:\n"
          "1. Select your major.\n"
          "2. Add one or more courses.\n"
          "3. Enter grades for midterm, final, and project.\n"
          "   - Midterm = 30%\n"
          "   - Final = 40%\n"
          "   - Project = 30%\n"
          "4. Press 'Calculate All' to see results.\n\n"
          "The app will show individual course GPA and overall GPA.\n"
          "Note: This app does not save data (session-based only).",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
