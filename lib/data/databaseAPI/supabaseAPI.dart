import 'package:fonhakaton2025/data/models/combined/taskWithUser.dart';
import 'package:fonhakaton2025/data/models/task.dart';
import 'package:fonhakaton2025/data/models/combined/taskWithState.dart';
import 'package:fonhakaton2025/data/models/user.dart';
import 'package:fonhakaton2025/data/supabase_helper.dart';

//////// STRUCTURES

// todo: make it match the ID-s in database.
// waiting_delete -> taskovi koji su prihvaceni i nagradjeni, ne vide se nigde, ali se brisu tek kada se obrise glavni task iz kog su nastali,
// kako ne bi jedan user mogao da radi isti quest vise puta!
enum TaskStatus { DOING, PENDING, ACCEPTED, DENIED, WAITING_DELETE }

class ReturnMessage {
  final bool success;
  final int statusCode;
  final String message;

  ReturnMessage(
      {required this.success, required this.statusCode, required this.message});

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
      };
}

////////////////////////////////////////////////////////////////// TASKS
/// todo: da li cemo znati koji user je ulogovan sve vreme, ili treba da fetchujem usera?

/// Vraca sve aktivne globalne taskove koje igrac nije vec prihvatio
Future<List<Task>> getAllAvailableTasks(String nickname) async {
  final supabase = SupabaseHelper.supabase;

  // Fetch task_ids associated with the given nickname
  // todo will this work?
  final List<Map<String, dynamic>> userTasks = await supabase
      .from('user_task')
      .select('task_id')
      .eq('nickname', nickname);

  final List<int> excludedTaskIds =
      userTasks.map((task) => task['task_id'] as int).toList();

  // Fetch global tasks that are NOT in user_task
  final List<Map<String, dynamic>> response =
      await supabase.from('tasks').select().not('id', 'in', excludedTaskIds);

  return response.map((task) => Task.fromJson(task)).toList();
}

/// Daje sve taskove za odredjenu grupu (vraca [] ako grupa ne postoji)
Future<List<Task>> getAllAvailableTasksFilter(
    String nickname, int groupId) async {
  final supabase = SupabaseHelper.supabase;

  // todo - check if the user is in the group from which they're asking for tasks
  final List<Map<String, dynamic>> userGroups = await supabase
      .from('user_group')
      .select('group_id')
      .eq('nickname', nickname)
      .eq('group_id', groupId);

  // HOW TO CHECK IF THIS WILL NOT BREAK ??? todo
  if (userGroups.isEmpty) {
    return [];
  }

  // Fetch task_ids associated with the given nickname
  final List<Map<String, dynamic>> userTasks = await supabase
      .from('user_task')
      .select('task_id')
      .eq('nickname', nickname);

  final List<int> excludedTaskIds =
      userTasks.map((task) => task['task_id'] as int).toList();

  // Fetch global tasks that are NOT in user_task
  final List<Map<String, dynamic>> response = await supabase
      .from('tasks')
      .select()
      .eq("group_id", groupId)
      .not('id', 'in', excludedTaskIds);

  return response.map((task) => Task.fromJson(task)).toList();
}

/////////////////////////////////////////////////////////////// USER_TASKS

/// Gets all tasks with the given STATUS code.
Future<List<TaskWithState>> getUserTasksWithStatus(
    int nickname, int status) async {
  // final doing_id = 1; // todo change!
  final supabase = SupabaseHelper.supabase;
  final List<Map<String, dynamic>> taskIds = await supabase
      .from('user_task')
      .select('task_id')
      .eq('state_id', status)
      .eq('nickname', nickname);

  final List<int> taskIdsList =
      taskIds.map((task) => task['task_id'] as int).toList();

  final List<Map<String, dynamic>> response =
      await supabase.from('tasks').select().inFilter('task_id', taskIdsList);

  return response.map((task) => TaskWithState.fromJson(task)).toList();
}

/// stvara ulaz u tabelu task_user, sa statusom "doing"
Future<ReturnMessage> CreateUserTask(String nickname, int taskId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final response = await supabase.from('user_task').insert(
        {'nickname': nickname, 'task_id': taskId, 'status': TaskStatus.DOING});
    if (response.error != null) {
      return ReturnMessage(
          success: false,
          statusCode: 500,
          message: "Database error: ${response.error!.message}");
    }

    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "User task $taskId , $nickname added successfully");
  } catch (e) {
    return ReturnMessage(
        success: false, statusCode: 500, message: "Exception: $e");
  }
}

/// Check if given status is valid?? and change task status --- todo
Future<ReturnMessage> SetUserTaskStatus(
    String nickname, int taskId, TaskStatus evaluation) async {
  try {
    final supabase = SupabaseHelper.supabase;

    if (!TaskStatus.values.contains(evaluation)) {
      return ReturnMessage(
          success: false,
          statusCode: 400,
          message: "Invalid status given: $evaluation");
    }

    final response = await supabase
        .from('user_task')
        .update({'state_id': evaluation.index}) // Use integer value of enum
        .match({
      'task_id': taskId,
      'nickname': nickname
    }); // Ensure both are included

    if (response.error != null) {
      return ReturnMessage(
          success: false,
          statusCode: 500,
          message: "Database error: ${response.error!.message}");
    }

    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "Task evaluation updated successfully");
  } catch (e) {
    return ReturnMessage(
        success: false, statusCode: 500, message: "Exception: $e");
  }
}

// Should be called when user abandons the task.
Future<ReturnMessage> removeUserTask(String nickname, int taskId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final response = await supabase.from('user_task').delete().match(
        {'task_id': taskId, 'nickname': nickname}); // Ensure both are included

    if (response.error != null) {
      return ReturnMessage(
          success: false,
          statusCode: 500,
          message: "Database error: ${response.error!.message}");
    }

    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "User task $taskId removed successfully");
  } catch (e) {
    return ReturnMessage(
        success: false, statusCode: 500, message: "Exception: $e");
  }
}

// Future<ReturnMessage> RemoveTaskAndInstances(int taskId) async{}

//////////////////////////////////////////////////////////// user_tasks_complete

/// TODO : napraviti completed_user_task koji pamti samo ime taska i usera, radi kao haha funny trenutka.
/// ovo nije hitno.
// getCompletedTasks() -> info_tasks[]

///////////////////////////////////////////////////////////////////// USERS

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
