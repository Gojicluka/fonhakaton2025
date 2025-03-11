import 'dart:convert';

/// User Model
class UserModel {
  final int id;
  final String name;
  final String index;
  final String fakultet;
  final int xp;
  final int trustLevel;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.index,
    required this.fakultet,
    this.xp = 0,
    this.trustLevel = 0,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        index: json['index_number'],
        fakultet: json['fakultet'],
        xp: json['xp'] ?? 0,
        trustLevel: json['trust_level'] ?? 0,
        avatarUrl: json['avatar_url'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'index_number': index,
        'fakultet': fakultet,
        'xp': xp,
        'trust_level': trustLevel,
        'avatar_url': avatarUrl,
      };
}

/// Student Group Model
class StudentGroup {
  final int id;
  final String ime;
  final List<int> userIds;
  final List<int> adminIds;

  StudentGroup({
    required this.id,
    required this.ime,
    required this.userIds,
    required this.adminIds,
  });

  factory StudentGroup.fromJson(Map<String, dynamic> json) => StudentGroup(
        id: json['id'],
        ime: json['ime'],
        userIds: List<int>.from(json['users'] ?? []),
        adminIds: List<int>.from(json['admins'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ime': ime,
        'users': userIds,
        'admins': adminIds,
      };
}

/// University Model
class University {
  final int id;
  final String name;
  final String location;

  University({
    required this.id,
    required this.name,
    required this.location,
  });

  factory University.fromJson(Map<String, dynamic> json) => University(
        id: json['id'],
        name: json['name'],
        location: json['location'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
      };
}

/// Task Model
class TaskModel {
  final int id;
  final int creatorId;
  final int durationByMinutes;
  final int xpGain;
  final bool done;
  final int? studentGroupId;
  final int universityId;
  final String location;
  final int howManyPeopleNeeded;
  final List<int> usersWorkingOnTask;

  TaskModel({
    required this.id,
    required this.creatorId,
    required this.durationByMinutes,
    required this.xpGain,
    required this.done,
    this.studentGroupId,
    required this.universityId,
    required this.location,
    required this.howManyPeopleNeeded,
    required this.usersWorkingOnTask,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'],
        creatorId: json['creator_id'],
        durationByMinutes: json['duration_minutes'],
        xpGain: json['xp_gain'],
        done: json['done'],
        studentGroupId: json['student_group_id'],
        universityId: json['university_id'],
        location: json['location'],
        howManyPeopleNeeded: json['people_needed'],
        usersWorkingOnTask: List<int>.from(json['useri_koji_rade'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'creator_id': creatorId,
        'duration_minutes': durationByMinutes,
        'xp_gain': xpGain,
        'done': done,
        'student_group_id': studentGroupId,
        'university_id': universityId,
        'location': location,
        'people_needed': howManyPeopleNeeded,
        'useri_koji_rade': usersWorkingOnTask,
      };
}
