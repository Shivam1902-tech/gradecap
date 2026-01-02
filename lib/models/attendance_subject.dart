class AttendanceSubject {
  String name;
  int total;
  int attended;

  AttendanceSubject({
    required this.name,
    required this.total,
    required this.attended,
  });

  double get percentage {
    if (total <= 0 || attended > total) return 0;
    return (attended / total) * 100;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'total': total,
      'attended': attended,
    };
  }

  factory AttendanceSubject.fromMap(Map<String, dynamic> map) {
    return AttendanceSubject(
      name: map['name'],
      total: map['total'],
      attended: map['attended'],
    );
  }
}
