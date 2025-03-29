import 'package:flutter/material.dart';

class TaskWithUser {
  final int taskId;
  final int? creatorId;
  final int durationMinutes;
  final int xpGain;
  final bool done;
  final int? studentGroupId;
  final int universityId;
  final String location;
  final int peopleNeeded;
  final bool isPublic;
  final String title;
  final String description;
  final int peopleApplied;
  final String color;
  final String iconName;

  // Fields from task_users table
  final int userId;
  final String? photo;
  final String? userDescription;
  final bool approved;
  final bool denied;

  TaskWithUser({
    required this.taskId,
    this.creatorId,
    required this.durationMinutes,
    required this.xpGain,
    this.done = false,
    this.studentGroupId,
    required this.universityId,
    required this.location,
    required this.peopleNeeded,
    this.isPublic = false,
    required this.title,
    required this.description,
    required this.peopleApplied,
    required this.color,
    this.iconName = 'task',
    required this.userId,
    this.photo,
    this.userDescription,
    this.approved = false,
    this.denied = false,
  });

  /// Convert JSON to `TaskWithUser`
  factory TaskWithUser.fromJson(Map<String, dynamic> json) {
    return TaskWithUser(
      taskId: json['task_id'],
      creatorId: json['creator_id'],
      durationMinutes: json['duration_minutes'],
      xpGain: json['xp_gain'],
      done: json['done'] ?? false,
      studentGroupId: json['student_group_id'],
      universityId: json['university_id'],
      location: json['location'],
      peopleNeeded: json['people_needed'],
      isPublic: json['is_public'] ?? false,
      title: json['title'],
      description: json['description'],
      peopleApplied: json['people_applied'],
      color: json['color'],
      iconName: json['icon'] ?? 'task',
      userId: json['user_id'],
      photo: json['photo'],
      userDescription: json['user_description'],
      approved: json['approved'] ?? false,
      denied: json['denied'] ?? false,
    );
  }

  /// Convert `TaskWithUser` to JSON
  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
      'creator_id': creatorId,
      'duration_minutes': durationMinutes,
      'xp_gain': xpGain,
      'done': done,
      'student_group_id': studentGroupId,
      'university_id': universityId,
      'location': location,
      'people_needed': peopleNeeded,
      'is_public': isPublic,
      'title': title,
      'description': description,
      'people_applied': peopleApplied,
      'color': color,
      'icon': iconName,
      'user_id': userId,
      'photo': photo,
      'user_description': userDescription,
      'approved': approved,
      'denied': denied,
    };
  }

  factory TaskWithUser.fromMap(Map<String, dynamic> map) {
    return TaskWithUser(
      taskId: map['id'],
      creatorId: map['creator_id'],
      durationMinutes: map['duration_minutes'],
      xpGain: map['xp_gain'],
      done: map['done'] ?? false,
      studentGroupId: map['student_group_id'],
      universityId: map['university_id'],
      location: map['location'],
      peopleNeeded: map['people_needed'],
      isPublic: map['is_public'] ?? false,
      title: map['title'],
      description: map['description'],
      peopleApplied: map['people_applied'],
      color: map['color'],
      iconName: map['icon'] ?? 'task',
      userId: map['user_id'],
      photo: map['photo'],
      userDescription: map['user_description'],
      approved: map['approved'] ?? false,
      denied: map['denied'] ?? false,
    );
  }
}
