class University {
  final int uniId;
  final String nameShort;
  final String nameFull;

  University({required this.uniId, required this.nameShort, required this.nameFull});

  factory University.fromJson(Map<String, dynamic> json) => University(
        uniId: json['uni_id'],
        nameShort: json['name_short'],
        nameFull: json['name_full'],
      );

  Map<String, dynamic> toJson() => {
        'uni_id': uniId,
        'name_short': nameShort,
        'name_full': nameFull,
      };
}