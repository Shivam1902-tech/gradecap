class Semester {
  final String name;
  final double sgpa;

  Semester({
    required this.name,
    required this.sgpa,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sgpa': sgpa,
    };
  }

  factory Semester.fromMap(Map<String, dynamic> map) {
    return Semester(
      name: map['name'],
      sgpa: map['sgpa'],
    );
  }
}
