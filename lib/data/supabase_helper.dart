import 'package:fonhakaton2025/data/models/task.dart';
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
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<UserModel?> getUserByName(String name) async {
    try {
      final response = await _supabase
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
      final response = await _supabase.from('task_users').insert({
        'TaskId': taskId,
        'UserId': userId,
        'Photo': photo,
        'Description': description,
        'Approved': approved,
        'Denied': denied, // New field
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
      final updateData = <String, dynamic>{};
      if (approved != null) updateData['Approved'] = approved;
      if (denied != null) updateData['Denied'] = denied;

      final response = await _supabase
          .from('task_users')
          .update(updateData)
          .match({'TaskId': taskId, 'UserId': userId});

      if (response.error != null) {
        print("Error updating task_users: ${response.error!.message}");
        return false;
      }

      return true;
    } catch (e) {
      print("Exception in updateTaskUserStatus: $e");
      return false;
    }
  }

  static Future<Task?> getTaskById(int id) async {
    try {
      final response =
          await _supabase.from('tasks').select('*').eq('id', id).maybeSingle();

      if (response == null) return null;
      return Task.fromJson(response);
    } catch (e) {
      print('Error fetching task: $e');
      return null;
    }
  }

  static Future<bool> updateTask({
    required int taskId,
    int? peopleNeeded,
    bool? done,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (peopleNeeded != null) updateData['PeopleNeeded'] = peopleNeeded;
      if (done != null) updateData['Done'] = done;

      final response = await _supabase
          .from('tasks')
          .update(updateData)
          .match({'id': taskId});

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
}
