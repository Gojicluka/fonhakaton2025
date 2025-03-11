class StudentGroup {
  final int id;
  final String ime;
  final int universityId;

  StudentGroup({
    required this.id,
    required this.ime,
    required this.universityId,
  });

  factory StudentGroup.fromJson(Map<String, dynamic> json) {
    return StudentGroup(
      id: json['id'],
      ime: json['ime'],
      universityId: json['university_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ime': ime,
      'university_id': universityId,
    };
  }
}
