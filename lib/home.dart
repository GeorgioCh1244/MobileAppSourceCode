import 'package:flutter/material.dart';
import 'grade.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? selectedMajor;
  final Map<String, List<String>> majors = {
    "Computer Science": ["CSCI 300", "CSCI 450", "CSCI 345"],
    "Information Systems": ["IS 210", "IS 330", "IS 410"],
  };

  final List<Course> selectedCourses = [];
  String _result = "";

  void addCourse(String courseName) {
    setState(() {
      selectedCourses.add(Course(courseName));
    });
  }

  void calculate() {
    if (selectedCourses.isEmpty) {
      setState(() {
        _result = "Error: Please add at least one course.";
      });
      return;
    }

    for (var course in selectedCourses) {
      if (course.midterm == -1 || course.finalExam == -1 || course.project == -1) {
        setState(() {
          _result = "Error: Please enter valid numeric grades.";
        });
        return;
      }

      if (course.midterm < 0 || course.midterm > 100 ||
          course.finalExam < 0 || course.finalExam > 100 ||
          course.project < 0 || course.project > 100) {
        setState(() {
          _result = "Error: Grades must be between 0 and 100.";
        });
        return;
      }
    }

    Major major = Major(selectedMajor ?? "Unknown", selectedCourses);
    setState(() {
      _result = major.toString();
    });
  }

  Widget _buildStyledTextField(String label, Function(String) onChanged) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade100,
        prefixIcon: const Icon(Icons.edit, color: Colors.indigo),
      ),
      onChanged: (val) {
        double? parsed = double.tryParse(val);
        onChanged(parsed != null ? val : "-1");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Grade Estimator"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Info text
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo, width: 2),
              ),
              child: const Text(
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(height: 20),
            const Text("Choose Major:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedMajor,
              hint: const Text("Select Major"),
              items: majors.keys.map((major) {
                return DropdownMenuItem(value: major, child: Text(major));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMajor = value;
                  selectedCourses.clear();
                });
              },
            ),

            const SizedBox(height: 20),
            if (selectedMajor != null) ...[
              const Text("Add Courses:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                children: majors[selectedMajor]!.map((courseName) {
                  return ElevatedButton.icon(
                    onPressed: () => addCourse(courseName),
                    icon: const Icon(Icons.book, color: Colors.white),
                    label: Text(
                      courseName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 20),
            for (var course in selectedCourses)
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          )),
                      const SizedBox(height: 10),
                      _buildStyledTextField("Midterm",
                          (val) => course.midterm = double.tryParse(val) ?? -1),
                      const SizedBox(height: 10),
                      _buildStyledTextField("Final",
                          (val) => course.finalExam = double.tryParse(val) ?? -1),
                      const SizedBox(height: 10),
                      _buildStyledTextField("Project",
                          (val) => course.project = double.tryParse(val) ?? -1),
                      const SizedBox(height: 10),
                      Text(
                        course.status(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: course.average() >= 60
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: calculate,
              icon: const Icon(Icons.calculate, color: Colors.white),
              label: const Text(
                "Calculate All",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),
            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _result.startsWith("Error")
                      ? Colors.red.shade50
                      : Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: _result.startsWith("Error")
                          ? Colors.red
                          : Colors.indigo,
                      width: 2),
                ),
                child: Text(
                  _result,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _result.startsWith("Error")
                        ? Colors.red
                        : Colors.indigo,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
