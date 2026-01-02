class Exam {
  String name;
  DateTime date;

  Exam({required this.name, required this.date});

  int get daysLeft {
    final now = DateTime.now();
    return date
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date.toIso8601String(),
    };
  }

  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      name: map['name'],
      date: DateTime.parse(map['date']),
    );
  }
}
