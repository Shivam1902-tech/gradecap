import '../widgets/ad_placeholder.dart';
import 'package:flutter/material.dart';
import '../models/semester.dart';
import '../utils/storage.dart';

class CgpaScreen extends StatefulWidget {
  const CgpaScreen({super.key});

  @override
  State<CgpaScreen> createState() => _CgpaScreenState();
}

class _CgpaScreenState extends State<CgpaScreen> {
  final List<Map<String, dynamic>> subjects = [];
  List<Semester> semesters = [];

  final Map<String, int> gradePoints = {
    'A+': 9,
    'A': 8,
    'B+': 7,
    'B': 6,
    'C+': 5,
    'C': 4,
    'D': 3,
    'E': 2,
    'F': 0,
  };

  @override
  void initState() {
    super.initState();
    loadSavedSemesters();
  }

  void loadSavedSemesters() async {
    semesters = await Storage.loadSemesters();
    setState(() {});
  }

  void addSubject() {
    setState(() {
      subjects.add({'credit': 1, 'grade': 'A+'});
    });
  }

  double calculateSGPA() {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var s in subjects) {
      totalPoints += s['credit'] * gradePoints[s['grade']]!;
     totalCredits += s['credit'] as int;

    }

    if (totalCredits == 0) return 0;
    return totalPoints / totalCredits;
  }

  double calculateCGPA() {
    if (semesters.isEmpty) return 0;
    double sum = semesters.fold(0, (a, b) => a + b.sgpa);
    return sum / semesters.length;
  }

  void saveSemester() async {
    final sgpa = calculateSGPA();
    if (sgpa == 0) return;

    final sem = Semester(
      name: 'Semester ${semesters.length + 1}',
      sgpa: sgpa,
    );

    semesters.add(sem);
    await Storage.saveSemesters(semesters);

    setState(() {
      subjects.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: addSubject,
            icon: const Icon(Icons.add),
            label: const Text('Add Subject'),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue:
                                subjects[index]['credit'].toString(),
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: 'Credits'),
                            onChanged: (v) {
                              subjects[index]['credit'] =
                                  int.tryParse(v) ?? 1;
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: subjects[index]['grade'],
                            decoration:
                                const InputDecoration(labelText: 'Grade'),
                            items: gradePoints.keys
                                .map(
                                  (g) => DropdownMenuItem(
                                    value: g,
                                    child: Text(g),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              subjects[index]['grade'] = v!;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Text(
            'SGPA: ${calculateSGPA().toStringAsFixed(2)}',
            style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const AdPlaceholder(),
          ElevatedButton(
            onPressed: saveSemester,
            child: const Text('Save Semester'),
          ),

          const Divider(height: 24),

          Text(
            'Overall CGPA: ${calculateCGPA().toStringAsFixed(2)}',
            style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: semesters.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.school),
                  title: Text(semesters[index].name),
                  trailing:
                      Text(semesters[index].sgpa.toStringAsFixed(2)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
