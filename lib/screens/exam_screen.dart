import '../utils/storage.dart';
import 'package:flutter/material.dart';
import '../models/exam.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  @override
void initState() {
  super.initState();
  loadExams();
}

void loadExams() async {
  final data = await Storage.loadExams(Exam.fromMap);
  exams.addAll(data.cast<Exam>());
  exams.sort((a, b) => a.date.compareTo(b.date));
  setState(() {});
}
void saveExams() {
  Storage.saveExams(exams);
}

  final List<Exam> exams = [];

  void addExam() async {
    final nameController = TextEditingController();
    DateTime? selectedDate;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Exam'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Exam Name',
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  selectedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 5),
                  );
                },
                child: const Text('Pick Exam Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    selectedDate != null) {
                 setState(() {
                  saveExams();

  exams.add(
    Exam(
      name: nameController.text,
      date: selectedDate!,
    ),
  );
  exams.sort((a, b) => a.date.compareTo(b.date));
});
saveExams();
Navigator.pop(context);

                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: addExam,
            icon: const Icon(Icons.add),
            label: const Text('Add Exam'),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: exams.isEmpty
                ? const Center(
                    child: Text(
                      'No exams added yet',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: exams.length,
                    itemBuilder: (context, index) {
                      final exam = exams[index];
                      final days = exam.daysLeft;

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.event),
                          title: Text(exam.name),
                          subtitle: Text(
                            days >= 0
                                ? '$days days left'
                                : 'Exam passed',
                          ),
                          trailing: days <= 3
                              ? const Icon(Icons.warning,
                                  color: Colors.red)
                              : null,
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
