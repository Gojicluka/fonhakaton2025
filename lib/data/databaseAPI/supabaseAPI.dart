import 'package:fonhakaton2025/data/models/combined/taskWithUser.dart';
import 'package:fonhakaton2025/data/models/task.dart';
import 'package:fonhakaton2025/data/models/combined/taskWithState.dart';
import 'package:fonhakaton2025/data/models/user.dart';
import 'package:fonhakaton2025/data/supabase_helper.dart';
import 'package:supabase/src/supabase_client.dart';

//////// STRUCTURES

// todo: make it match the ID-s in database.
// waiting_delete -> taskovi koji su prihvaceni i nagradjeni, ne vide se nigde, ali se brisu tek kada se obrise glavni task iz kog su nastali,
// kako ne bi jedan user mogao da radi isti quest vise puta!
enum TaskStatus { DOING, PENDING, ACCEPTED, DENIED, WAITING_DELETE }

enum Groups { NONE, ADDMORE }

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
  final List<Map<String, dynamic>> userTasks = await supabase
      .from('user_task')
      .select('task_id')
      .eq('nickname', nickname);

  final List<int> excludedTaskIds =
      userTasks.map((task) => task['task_id'] as int).toList();

  // fetch user groups as a list
  final List<Map<String, dynamic>> userGroups = await supabase
      .from('user_group')
      .select('group_id')
      .eq('nickname', nickname);

  final List<int> userGroupsList =
      userGroups.map((task) => task['group_id'] as int).toList();

  // Fetch all tasks that are NOT in user_task and match user groups.
  final List<Map<String, dynamic>> response = await supabase
      .from('tasks')
      .select()
      .not('task_id', 'in', excludedTaskIds)
      .inFilter('group_id', userGroupsList);

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
      .not('task_id', 'in', excludedTaskIds);

  return response.map((task) => Task.fromJson(task)).toList();
}

/// stvara ulaz u tabelu task_user, sa statusom "doing"
Future<ReturnMessage> CreateTask(Task task) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final response = await supabase.from('tasks').insert({
      'task_id': task.taskId,
      'name': task.name,
      'description': task.description,
      'place': task.place,
      'uni_id': task.uniId,
      'xp': task.xp,
      'group_id': task.groupId,
      'urgent': task.urgent,
      'exists_for_time': task.existsForTime,
      'ppl_needed': task.pplNeeded,
      'ppl_doing': task.pplDoing,
      'ppl_submitted': task.pplSubmitted,
      'created_by': task.createdBy,
      'color': task.color,
      'icon_name': task.iconName,
      'duration_in_minutes': task.durationInMinutes,
    });

    if (response.error != null) {
      return ReturnMessage(
          success: false,
          statusCode: 500,
          message: "Database error: ${response.error!.message}");
    }

    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "Task '${task.name}' created successfully");
  } catch (e) {
    return ReturnMessage(
        success: false, statusCode: 500, message: "Exception: $e");
  }
}

/////////////////////////////////////////////////////////////// USER_TASKS

/// Gets all tasks with the given STATUS code.
Future<List<TaskWithState>> getUserTasksWithStatus(
    String nickname, TaskStatus status) async {
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

    // update pplDoing by 1.
    var updateDoing = await updateTaskPeopleDoing(supabase, taskId, 1);

    if (updateDoing.error != null) {
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

Future<dynamic> updateTaskPeopleDoing(
    SupabaseClient supabase, int taskId, int amount) async {
  final updateDoing = await supabase.from('tasks').update({
    'ppl_doing': supabase
        .rpc('increment', params: {'column': 'ppl_doing', 'amount': amount})
  }).eq('task_id', taskId);
  return updateDoing;
}

Future<dynamic> updateTaskPeopleSubmitted(
    SupabaseClient supabase, int taskId, int amount) async {
  final updateSubmitted = await supabase.from('tasks').update({
    'ppl_submitted': supabase
        .rpc('increment', params: {'column': 'ppl_submitted', 'amount': 1})
  }).eq('task_id', taskId);
  return updateSubmitted;
}

/// Update user task to given status. if updating to submitted -> update ppl_submitted
Future<ReturnMessage> UpdateUserTaskStatus(
    String nickname, int taskId, TaskStatus newStatus) async {
  try {
    final supabase = SupabaseHelper.supabase;

    if (!TaskStatus.values.contains(newStatus)) {
      return ReturnMessage(
          success: false,
          statusCode: 400,
          message: "Invalid status given: $newStatus");
    }

    final response = await supabase
        .from('user_task')
        .update({'state_id': newStatus.index}) // Use integer value of enum
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

    if (newStatus == TaskStatus.PENDING) {
      final response = await updateTaskPeopleSubmitted(supabase, taskId, 1);
      if (response.error != null) {
        print("nooo");
      }
    }
    if (newStatus == TaskStatus.DENIED || newStatus == TaskStatus.ACCEPTED) {
      final response = await updateTaskPeopleSubmitted(supabase, taskId, -1);
      if (response.error != null) {
        print("nooo");
      }
    }

    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "Task status updated successfully");
  } catch (e) {
    return ReturnMessage(
        success: false, statusCode: 500, message: "Exception: $e");
  }
}

// Should be called when user abandons the task.
Future<ReturnMessage> deleteUserTask(String nickname, int taskId) async {
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

    // make it so that one person less is doing the task.
    var updateDoing = await updateTaskPeopleDoing(supabase, taskId, -1);

    if (updateDoing.error != null) {
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

Future<ReturnMessage> updateUserXP(String nickname, int amount) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final response = await supabase.from('users').update({
      'xp':
          supabase.rpc('increment', params: {'column': 'xp', 'amount': amount})
    }).eq('nickname', nickname);

    if (response.error != null) {
      return ReturnMessage(
          success: false,
          statusCode: 500,
          message: "Database error: ${response.error!.message}");
    }

    return ReturnMessage(
        success: true, statusCode: 200, message: "User got XP $amount");
  } catch (e) {
    return ReturnMessage(
        success: false, statusCode: 500, message: "Exception: $e");
  }
}
