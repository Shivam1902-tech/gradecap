import '../utils/storage.dart';
import 'package:flutter/material.dart';
import '../models/task.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  @override
void initState() {
  super.initState();
  loadTasks();
}

void loadTasks() async {
  final data = await Storage.loadTasks(Task.fromMap);
  tasks.addAll(data.cast<Task>());
  setState(() {});
}
void saveTasks() {
  Storage.saveTasks(tasks);
}

  final List<Task> tasks = [];
  final TextEditingController controller = TextEditingController();

  void addTask() {
  if (controller.text.trim().isEmpty) return;

  setState(() {
    tasks.add(Task(title: controller.text.trim()));
    controller.clear();
  });
  saveTasks();
}


  void toggleTask(int index) {
  setState(() {
    tasks[index].completed = !tasks[index].completed;
  });
  saveTasks();
}


 void deleteTask(int index) {
  setState(() {
    tasks.removeAt(index);
  });
  saveTasks();
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'New Task',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_circle, size: 32),
                onPressed: addTask,
              ),
            ],
          ),
          const SizedBox(height: 12),

          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks yet. Add your first task!',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: task.completed,
                            onChanged: (_) => toggleTask(index),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () => deleteTask(index),
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
