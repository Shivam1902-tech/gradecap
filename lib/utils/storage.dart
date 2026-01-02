import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/semester.dart';

class Storage {
  static const String semesterKey = 'semesters';

  static Future<void> saveSemesters(List<Semester> semesters) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data =
        semesters.map((s) => jsonEncode(s.toMap())).toList();
    await prefs.setStringList(semesterKey, data);
  }
static const String attendanceKey = 'attendance';

static Future<void> saveAttendance(
    List<dynamic> subjects) async {
  final prefs = await SharedPreferences.getInstance();
  final data =
      subjects.map((s) => jsonEncode(s.toMap())).toList();
  await prefs.setStringList(attendanceKey, data);
}
static const String examKey = 'exams';

static Future<void> saveExams(List exams) async {
  final prefs = await SharedPreferences.getInstance();
  final data =
      exams.map((e) => jsonEncode(e.toMap())).toList();
  await prefs.setStringList(examKey, data);
}
static const String taskKey = 'tasks';

static Future<void> saveTasks(List tasks) async {
  final prefs = await SharedPreferences.getInstance();
  final data =
      tasks.map((t) => jsonEncode(t.toMap())).toList();
  await prefs.setStringList(taskKey, data);
}

static Future<List> loadTasks(Function fromMap) async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getStringList(taskKey);
  if (data == null) return [];
  return data.map((e) => fromMap(jsonDecode(e))).toList();
}

static Future<List> loadExams(Function fromMap) async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getStringList(examKey);
  if (data == null) return [];
  return data.map((e) => fromMap(jsonDecode(e))).toList();
}

static Future<List<dynamic>> loadAttendance(
    Function fromMap) async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getStringList(attendanceKey);
  if (data == null) return [];
  return data.map((e) => fromMap(jsonDecode(e))).toList();
}

  static Future<List<Semester>> loadSemesters() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(semesterKey);

    if (data == null) return [];

    return data
        .map((e) => Semester.fromMap(jsonDecode(e)))
        .toList();
  }
}
