import 'package:fonhakaton2025/data/models/task.dart';
import 'package:fonhakaton2025/data/models/task_with_user.dart';
import 'package:fonhakaton2025/data/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:fonhakaton2025/data/models.dart";

Future<void> init_supabase() async {
  print("Loading");
  print("Initializing Supabase...");
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );
}

class SupabaseHelper {
  static final SupabaseClient supabase = Supabase.instance.client;

  static Future<UserModel?> getUserByName(String name) async {
    try {
      final response = await supabase
          .from('users')
          .select('*')
          .eq('name', name)
          .maybeSingle();

      if (response == null) return null;
      return UserModel.fromJson(response);
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  /// Inserts a user-task relationship into `task_users`
  static Future<bool> addUserToTask({
    required int taskId,
    required int userId,
    String? photo,
    String? description,
    bool approved = false,
    bool denied = false,
  }) async {
    try {
      final response = await supabase.from('task_users').upsert({
        'task_id': taskId,
        'user_id': userId,
        'photo': photo,
        'description': description,
        'approved': approved,
        'denied': denied,
      });

      if (response.error != null) {
        print("Error inserting into task_users: ${response.error!.message}");
        return false;
      }

      return true; // Success
    } catch (e) {
      print("Exception in addUserToTask: $e");
      return false;
    }
  }

  /// Updates approval or denial status of a task-user relationship
  static Future<bool> updateTaskUserStatus({
    required int taskId,
    required int userId,
    bool? approved,
    bool? denied,
  }) async {
    try {
      final response = await supabase
          .from('task_users')
          .delete()
          .match({'task_id': taskId, 'user_id': userId});

      if (response.error != null) {
        print("Error deleting task_user: ${response.error!.message}");
        return false;
      }

      return true;
      // if (approved != null) updateData['Approved'] = approved;
      // if (denied != null) updateData['Denied'] = denied;

      // final response = await supabase
      //     .from('task_users')
      //     .update(updateData)
      //     .match({'task_id': taskId, 'UserId': userId});

      // if (response.error != null) {
      //   print("Error updating task_users: ${response.error!.message}");
      //   return false;
      // }

      // return true;
    } catch (e) {
      print("Exception in updateTaskUserStatus: $e");
      return false;
    }
  }

  static Future<Task?> getTaskById(int id) async {
    try {
      final response =
          await supabase.from('tasks').select('*').eq('id', id).maybeSingle();

      if (response == null) return null;
      return Task.fromJson(response);
    } catch (e) {
      print('Error fetching task: $e');
      return null;
    }
  }

  static Future<bool> updateUserXP({
    required int userId,
    required int xpAmount,
  }) async {
    try {
      final response = await supabase
          .from('users')
          .update({'xp': xpAmount}).match({'id': userId});

      if (response.error != null) {
        print("Error updating user XP: ${response.error!.message}");
        return false;
      }

      return true;
    } catch (e) {
      print("Exception in updateUserXP: $e");
      return false;
    }
  }

  static Future<bool> updateTask({
    required int taskId,
    int? peopleNeeded,
    bool? done,
    int? peopleApplied,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (peopleNeeded != null) updateData['PeopleNeeded'] = peopleNeeded;
      if (done != null) updateData['Done'] = done;
      if (peopleApplied != null) updateData['people_applied'] = peopleApplied;

      final response =
          await supabase.from('tasks').update(updateData).match({'id': taskId});

      if (response.error != null) {
        print("Error updating task: ${response.error!.message}");
        return false;
      }

      return true;
    } catch (e) {
      print("Exception in updateTask: $e");
      return false;
    }
  }

  static Future<bool> updateTaskPeopleApplied({
    required int taskId,
    required int peopleApplied,
  }) async {
    return await supabase
        .from('tasks')
        .update({'people_applied': peopleApplied})
        .match({'id': taskId})
        .then((_) => true) // ✅ If successful, return true
        .catchError((error) {
          print("Error updating task people applied: $error");
          return false;
        });
  }

  static Future<bool> insertTask(Task task) async {
    try {
      final response =
          await supabase.from('tasks').insert(task.toJson()..remove('id'));

      if (response.error != null) {
        print("Error inserting task: ${response.error!.message}");
        return false;
      }

      return true;
    } catch (e) {
      print("Exception in insertTask: $e");
      return false;
    }
  }

  static Future<List<TaskWithUser>> getAllTaskWithUsers() async {
    final PostgrestList response = await supabase.from('task_users').select('''
            task_id, 
            tasks:task_id (
                id, creator_id, duration_minutes, xp_gain, done, student_group_id,
                university_id, location, people_needed, is_public, title, description, 
                people_applied, color, icon
            ),
            user_id, photo, description, approved, denied
        ''');

    return response.map((taskUser) {
      final task = taskUser['tasks'];
      return TaskWithUser(
        taskId: task['id'],
        creatorId: task['creator_id'],
        durationMinutes: task['duration_minutes'],
        xpGain: task['xp_gain'],
        done: task['done'],
        studentGroupId: task['student_group_id'],
        universityId: task['university_id'],
        location: task['location'],
        peopleNeeded: task['people_needed'],
        isPublic: task['is_public'],
        title: task['title'],
        description: task['description'],
        peopleApplied: task['people_applied'],
        color: task['color'],
        iconName: task['icon'],
        userId: taskUser['user_id'],
        photo: taskUser['photo'],
        userDescription: taskUser['description'],
        approved: taskUser['approved'],
        denied: taskUser['denied'],
      );
    }).toList();
  }

  /// Check if a user is assigned to a specific task
  static Future<bool> isUserOnTask(int taskId, int userId) async {
    try {
      final response = await supabase
          .from('task_users')
          .select()
          .match({'task_id': taskId, 'user_id': userId}).maybeSingle();

      return response != null;
    } catch (e) {
      print("Exception in isUserOnTask: $e");
      return false;
    }
  }
}
