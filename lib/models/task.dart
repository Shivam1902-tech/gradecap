class Task {
  String title;
  bool completed;

  Task({required this.title, this.completed = false});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'completed': completed,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      completed: map['completed'],
    );
  }
}
