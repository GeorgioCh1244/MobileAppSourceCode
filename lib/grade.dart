// grade.dart

class Course {
  final String name;
  double midterm;
  double finalExam;
  double project;

  Course(this.name, {this.midterm = 0, this.finalExam = 0, this.project = 0});

  // Weighted average: Midterm 30%, Final 40%, Project 30%
  double average() {
    return (midterm * 0.3) + (finalExam * 0.4) + (project * 0.3);
  }

  // GPA calculation with fail penalty
  double gpa() {
    double avg = average();

    double baseGpa;
    if (avg >= 90) baseGpa = 4.0;
    else if (avg >= 80) baseGpa = 3.0;
    else if (avg >= 70) baseGpa = 2.0;
    else if (avg >= 60) baseGpa = 1.0;
    else baseGpa = 0.7;

    if (avg < 60) {
      baseGpa = (baseGpa - 0.7).clamp(0.0, 4.0);
    }

    return baseGpa;
  }

  String status() => average() >= 60 ? "PASS ✅" : "FAIL ❌";

  @override
  String toString() {
    return "$name\n"
           "Midterm: $midterm\n"
           "Final: $finalExam\n"
           "Project: $project\n"
           "Weighted Average: ${average().toStringAsFixed(2)}%\n"
           "GPA: ${gpa().toStringAsFixed(2)}\n"
           "Status: ${status()}";
  }
}

class Major {
  final String name;
  final List<Course> courses;

  Major(this.name, this.courses);

  double overallAverage() {
    if (courses.isEmpty) return 0;
    return courses.map((c) => c.average()).reduce((a, b) => a + b) / courses.length;
  }

  double overallGpa() {
    if (courses.isEmpty) return 0;
    return courses.map((c) => c.gpa()).reduce((a, b) => a + b) / courses.length;
  }

  @override
  String toString() {
    String courseDetails = courses.map((c) => c.toString()).join("\n\n");
    return "Major: $name\n\n$courseDetails\n\n"
           "Overall Weighted Average: ${overallAverage().toStringAsFixed(2)}%\n"
           "Overall GPA: ${overallGpa().toStringAsFixed(2)}";
  }
}
