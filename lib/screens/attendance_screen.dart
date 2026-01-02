import '../utils/storage.dart';
import 'package:flutter/material.dart';
import '../models/attendance_subject.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
void initState() {
  super.initState();
  loadData();
}

void loadData() async {
  final data = await Storage.loadAttendance(
      AttendanceSubject.fromMap);
  subjects.addAll(data.cast<AttendanceSubject>());
  setState(() {});
}

  final List<AttendanceSubject> subjects = [];

void saveData() {
  Storage.saveAttendance(subjects);
}

  void addSubject() {
  setState(() {
    subjects.add(
      AttendanceSubject(name: 'Subject', total: 0, attended: 0),
    );
  });
  saveData();
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
          const SizedBox(height: 12),

          Expanded(
            child: subjects.isEmpty
                ? const Center(
                    child: Text(
                      'No subjects added yet',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      final percent = subject.percentage;

                      return Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                initialValue: subject.name,
                                decoration: const InputDecoration(
                                  labelText: 'Subject Name',
                                ),
                                onChanged: (v) {
  setState(() {
    subject.name = v;
  });
    saveData();
},

                              ),
                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      initialValue:
                                          subject.total.toString(),
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Total Classes',
                                      ),
                                      onChanged: (v) {
                                        subject.total =
                                            int.tryParse(v) ?? 0;
                                        setState(() {
                                            saveData();
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue:
                                          subject.attended.toString(),
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Attended',
                                      ),
                                      onChanged: (v) {
                                        subject.attended =
                                            int.tryParse(v) ?? 0;
                                        setState(() {
                                            saveData();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),
                              Text(
                                'Attendance: ${percent.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: percent >= 75 ? Colors.green : Colors.red,

                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
