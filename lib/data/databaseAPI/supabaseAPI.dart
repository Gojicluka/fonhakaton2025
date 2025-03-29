import 'package:fonhakaton2025/data/models/combined/taskWithUser.dart';
import 'package:fonhakaton2025/data/models/task.dart';
import 'package:fonhakaton2025/data/models/combined/taskWithState.dart';
import 'package:fonhakaton2025/data/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fonhakaton2025/data/supabase_helper.dart';
import 'package:fonhakaton2025/data/models/user.dart';

// TASKS
/// TASKS GET

Future<UserModel?> getUserByName(String name) async {
  try {
    final response = await SupabaseHelper.supabase
        .from('users')
        .select('*')
        .eq('nickname', name)
        .maybeSingle(); // todo would it be wise to use an enum?

    if (response == null) return null;
    return UserModel.fromJson(response);
  } catch (e) {
    print('Error fetching user: $e');
    return null;
  }
}

// Future<List<Task>> getGlobalTasks() async {
//   final PostgrestList response = await SupabaseHelper.supabase
//       .from('tasks')
//       .select()
//       .eq("group_id", 0);

//   return response.map((Task) {
//     final task = Task['tasks'];
//     return Task(
//       taskId: task['id'],
//       creatorId: task['creator_id'],
//       durationMinutes: task['duration_minutes'],
//       xpGain: task['xp_gain'],
//       done: task['done'],
//       studentGroupId: task['student_group_id'],
//       universityId: task['university_id'],
//       location: task['location'],
//       peopleNeeded: task['people_needed'],
//       isPublic: task['is_public'],
//       title: task['title'],
//       description: task['description'],
//       peopleApplied: task['people_applied'],
//       color: task['color'],
//       iconName: task['icon'],
//       userId: taskUser['user_id'],
//       photo: taskUser['photo'],
//       userDescription: taskUser['description'],
//       approved: taskUser['approved'],
//       denied: taskUser['denied'],
//     );
//   }).toList();
// }

///
/// todo: da li cemo znati koji user je ulogovan sve vreme, ili treba da fetchujem usera?
/// Vraca sve aktivne globalne taskove koje igrac nije vec prihvatio
Future<List<Task>> getGlobalTasks() async {
  final List<Map<String, dynamic>> response =
      await SupabaseHelper.supabase.from('tasks').select().eq("group_id", 0);

  return response.map((task) => Task.fromJson(task)).toList();
}

///
/// todo - auth?
/// Daje taskove za odredjenu grupu
Future<List<Task>> getGroupTasks({required int group_id}) async {
  final List<Map<String, dynamic>> response = await SupabaseHelper.supabase
      .from('tasks')
      .select()
      .eq('group_id', group_id);

  return response.map((task) => Task.fromJson(task)).toList();
}

///
/// todo - how to fetch the ID that is "doing" ?
/// Gets all tasks that the user is currently doing 
Future<List<TaskWithState>> getDoingTasks({required int nickname}) async {
  final state_id = 1; // todo change!
  final List<Map<String, dynamic>> response = await SupabaseHelper.supabase
      .from('user_task')
      .select()
      .eq('state_id', state_id)
      .eq('nickname', nickname);

  return response.map((task) => TaskWithState.fromJson(task)).toList();
}


// getPendingTasks(user id, state=doing) -> task_with_status[]

// getToReviewTasks(user id, state=doing) -> task_with_status[]

// getReviewedTasks() -> task_with_status[]

// getCompletedTasks() -> info_tasks[]





// /// UPDATE: Updates approval or denial status of a task-user relationship
// Future<bool> updateTaskUserStatus({
//   required int taskId,
//   required int userId,
//   bool? approved,
//   bool? denied,
// }) async {
//   try {
//     final response = await supabase
//         .from('task_users')
//         .delete()
//         .match({'task_id': taskId, 'user_id': userId});

//     if (response.error != null) {
//       print("Error deleting task_user: ${response.error!.message}");
//       return false;
//     }

//     return true;
//     // if (approved != null) updateData['Approved'] = approved;
//     // if (denied != null) updateData['Denied'] = denied;

//     // final response = await supabase
//     //     .from('task_users')
//     //     .update(updateData)
//     //     .match({'task_id': taskId, 'UserId': userId});

//     // if (response.error != null) {
//     //   print("Error updating task_users: ${response.error!.message}");
//     //   return false;
//     // }

//     // return true;
//   } catch (e) {
//     print("Exception in updateTaskUserStatus: $e");
//     return false;
//   }
// }

/// Checks if a user is assigned to a specific task
Future<bool> isUserOnTask({required String? user_nickname, required int task_id}) async {
  return false; // todo implement this
}

Future<List<TaskWithUser>> getAllTaskWithUsers() async {
  return []; // todo implement this
}

/// Inserts a new task into the database
Future<bool> insertTask(Task task) async {
  return true;
}