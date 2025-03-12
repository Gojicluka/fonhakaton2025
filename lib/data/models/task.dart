import 'package:flutter/material.dart';

class Task {
  final int id;
  final int? creatorId;
  final int durationMinutes;
  final int xpGain;
  final bool done;
  final int? studentGroupId; // Nullable
  final int universityId;
  final String location;
  final int peopleNeeded;
  final bool isPublic; // New field
  final String title;
  final String description;
  final int peopleApplied;
  final String color;
  final String iconName; // New icon field

  Task({
    required this.id,
    this.creatorId,
    required this.durationMinutes,
    required this.xpGain,
    this.done = false,
    this.studentGroupId,
    required this.universityId,
    required this.location,
    required this.peopleNeeded,
    this.isPublic = false, // Default value
    required this.title,
    required this.description,
    required this.peopleApplied,
    required this.color,
    this.iconName = 'task', // Default icon
  });

  Task t1 = Task(
    id: 1,
    creatorId: 1,
    durationMinutes: 240,
    xpGain: 100,
    universityId: 102,
    location: "Bulevar kralja Aleksandra 67, Beograd 11000",
    peopleNeeded: 3,
    title: "Redar na ulazu",
    description: "Sedite u ulaznom hodniku fakulteta i proveravate ljudima indekse.",
    peopleApplied: 0,
    color: "Colors.teal.withOpacity(0.8)"
  );

  Task t2 = Task(
    id: 2,
    creatorId: 1,
    durationMinutes: 15,
    xpGain: 30,
    universityId: 102,
    location: "Bulevar kralja Aleksandra 67, Beograd 11000",
    peopleNeeded: 5,
    title: "Voda",
    description:"Kada voda stigne danas treba nam 5 ljudi da unosi pakete na fakultet.",
    peopleApplied: 0,
    color: " Colors.red.withOpacity(0.8)"
  );

  Task t3 = Task(
    id: 3,
    creatorId: 2,
    durationMinutes: 300,
    xpGain: 100,
    universityId: 102,
    location: "Filozofski fakultet",
    peopleNeeded: 2,
    title:"KRGS",
    description: "Trebaju nam jos 2 osobe za krgs veceras",
    peopleApplied:0,
    color: "Colors.indigo.withOpacity(0.8)"
  );

  Task t4 = Task(
    id: 4,
    creatorId: 7,
    durationMinutes: 30,
    xpGain: 30,
    studentGroupId: 101,
    universityId: 102,
    location: "remote",
    peopleNeeded: 1,
    title: "Izvestaj",
    description: "Neko treba da sastavi izvestaj iz danasnjeg zapisnika do veceras.",
    peopleApplied: 0,
    color: "Colors.orange.withOpacity(0.8)"
  );
/*
  Task t5 = Task(
    id: 4,
    creatorId: 7,
    durationMinutes: 30,
    xpGain: 30,
    studentGroupId: 101,
    universityId: 102,
    location: "remote",
    peopleNeeded: 1,
    title: "Izvestaj",
    description: "Neko treba da sastavi izvestaj iz danasnjeg zapisnika do veceras.",
    peopleApplied: 0,
    color: "Colors.orange.withOpacity(0.8)"
  );*/
   

  /// Convert JSON to `Task`
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      creatorId: json['creator_id'],
      durationMinutes: json['duration_minutes'],
      xpGain: json['xp_gain'],
      done: json['done'] ?? false,
      studentGroupId: json['student_group_id'], // Nullable
      universityId: json['university_id'],
      location: json['location'],
      peopleNeeded: json['people_needed'],
      isPublic: json['is_public'] ?? false, // Default: false
      title: json['title'],
      description: json['description'],
      peopleApplied: json['people_applied'],
      color: json['color'],
      iconName: json['icon'] ?? 'task', // Default icon
    );
  }

  /// Convert `Task` to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'duration_minutes': durationMinutes,
      'xp_gain': xpGain,
      'done': done,
      'student_group_id': studentGroupId, // Nullable
      'university_id': universityId,
      'location': location,
      'people_needed': peopleNeeded,
      'is_public': isPublic,
      'title': title,
      'description': description,
      'people_applied': peopleApplied,
      'color': color,
      'icon': iconName,
    };
  }
}
