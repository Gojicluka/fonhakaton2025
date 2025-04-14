import 'dart:io';
import 'package:fonhakaton2025/data/models/TasksPredetermined.dart';
import 'package:fonhakaton2025/data/models/combined/achWithUser.dart';
import 'package:fonhakaton2025/data/models/combined/taskWithUser.dart';
import 'package:fonhakaton2025/data/models/statPoint.dart';
import 'package:fonhakaton2025/data/models/task.dart';
import 'package:fonhakaton2025/data/models/combined/taskWithState.dart';
import 'package:fonhakaton2025/data/models/user.dart';
import 'package:fonhakaton2025/data/supabase_helper.dart';
// import 'package:postgrest/src/types.dart';
import 'package:supabase/src/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:fonhakaton2025/data/models/Group.dart';
import 'package:fonhakaton2025/data/models/UserGroup.dart';
import 'package:fonhakaton2025/data/models/GroupJoinRequest.dart';

//////// STRUCTURES

// todo: make it match the ID-s in database.
// waiting_delete -> taskovi koji su prihvaceni i nagradjeni, ne vide se nigde, ali se brisu tek kada se obrise glavni task iz kog su nastali,
// kako ne bi jedan user mogao da radi isti quest vise puta!
enum Groups { NOGROUP, ADDMORE }

// bucket names for storage
final String TASKCOMPLETIONS_BUCKET_NAME = "taskcompletions";

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

// struktura api poziva:
// - sve u try catch, a hvatanje errora vraca objekat koji ima ime funkcije i stampa error
// - samo jedan catch, nema potrebe za drugim jer ce nesto baciti gresku svakako!
// ...

// helper functions

// todo apr10

Future<List<Map<String, dynamic>>> getUserGroupsWithNames(
    String nickname) async {
  try {
    final supabase = SupabaseHelper.supabase;
    List<int> userGroups = await getUserGroups(nickname);

    final getUserGroupsWithNames = await supabase
        .from('groups')
        .select('group_id, name')
        .inFilter('group_id', userGroups);

    return getUserGroupsWithNames;
  } catch (e) {
    print('Error in getUserGroupsWithNames: $e');
    return [];
  }
}

Future<List<int>> getUserGroups(String nickname) async {
  try {
    final supabase = SupabaseHelper.supabase;
    final userGroups = await supabase
        .from('user_group')
        .select('group_id')
        .eq('nickname', nickname);

    final List<int> userGroupsList =
        userGroups.map((task) => task['group_id'] as int).toList();
    userGroupsList.add(Groups.NOGROUP.index);

    return userGroupsList;
  } catch (e) {
    print('Error in getUserGroups: $e');
    return [];
  }
}

Future<List<int>> getTasksCreatedBy(String nickname) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final List<Map<String, dynamic>> userTasks = await supabase
        .from('tasks')
        .select('task_id')
        .eq('created_by', nickname);
    return userTasks.map((task) => task['task_id'] as int).toList();
  } catch (e) {
    print('Error in getTasksCreatedBy: $e');
    return [];
  }
}

Future<List<int>> getUserTaskIds(String nickname) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final List<Map<String, dynamic>> userTasks = await supabase
        .from('user_task')
        .select('task_id')
        .eq('nickname', nickname);
    return userTasks.map((task) => task['task_id'] as int).toList();
  } catch (e) {
    print('Error in getUserTaskIds: $e');
    return [];
  }
}

Future<int> getUserUniversity(String nickname) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final response = await supabase
        .from('users')
        .select('uni_id')
        .eq('nickname', nickname)
        .maybeSingle();

    // todo check if username exists???
    if (response == null) return -1;
    return response['uni_id'] as int; // todo will this throw err?
  } catch (e) {
    print('Error in getUserUniversity: $e');
    return -1;
  }
}

////////////////////////////////////////////////////////////////// TASKS
/// todo: da li cemo znati koji user je ulogovan sve vreme, ili treba da fetchujem usera?

/// Vraca sve aktivne globalne taskove koje igrac nije vec prihvatio
// Future<List<Task>> getAllAvailableTasks(String nickname) async {
Future<List<Task>> getAllGroupTasks(String nickname) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // Fetch task_ids associated with the given nickname - both taken quests and made quests.
    List<int> excludedTaskIds = await getUserTaskIds(nickname);
    List<int> getTasksUserCreated = await getTasksCreatedBy(nickname);
    int userUniversity = await getUserUniversity(nickname);

    print("excluded task ids $excludedTaskIds");
    print("user created ids $getTasksUserCreated");

    // fetch user groups as a list
    final List<int> userGroupsList = await getUserGroups(nickname);

    print("user groups $userGroupsList");

    // Fetch all tasks that are NOT in user_task and match user groups.
    final List<Map<String, dynamic>> response = await supabase
        .from('tasks')
        .select()
        .not('task_id', 'in', excludedTaskIds)
        .not('task_id', 'in', getTasksUserCreated)
        .eq('uni_id', userUniversity)
        .inFilter('group_id', userGroupsList);

    // return response.map((task) => Task.fromJson(task)).toList();
    return response.map((task) => Task.fromJson(task)).toList();
  } catch (e) {
    print('Error in getAllAvailableTasks: $e');
    return [];
  }
}

Future<List<Task>> getAllGlobalTasks(String nickname) async {
  final supabase = SupabaseHelper.supabase;

  // Fetch task_ids associated with the given nickname - both taken quests and made quests.
  List<int> excludedTaskIds = await getUserTaskIds(nickname);
  List<int> getTasksUserCreated = await getTasksCreatedBy(nickname);
  int userUniversity = await getUserUniversity(nickname);

  print("excluded task ids $excludedTaskIds");
  print("user created ids $getTasksUserCreated");

  // fetch user groups as a list
  final List<int> userGroupsList = await getUserGroups(nickname);

  print("user groups $userGroupsList");

  // Fetch all tasks that are NOT in user_task and match user groups.
  final List<Map<String, dynamic>> response = await supabase
      .from('tasks')
      .select()
      .not('task_id', 'in', excludedTaskIds)
      .not('task_id', 'in', getTasksUserCreated)
      .eq('uni_id', userUniversity)
      .inFilter('group_id', userGroupsList);

  // return response.map((task) => Task.fromJson(task)).toList();
  return response.map((task) => Task.fromJson(task)).toList();
}

/// Daje sve taskove za odredjenu grupu (vraca [] ako grupa ne postoji)
Future<List<Task>> getAllAvailableTasksFilter(
    String nickname, int groupId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // check if the user is in the group from which they're asking for tasks
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
    List<int> excludedTaskIds = await getUserTaskIds(nickname);
    List<int> getTasksUserCreated = await getTasksCreatedBy(nickname);
    int userUniversity = await getUserUniversity(nickname);

    // Fetch global tasks that are NOT in user_task
    final List<Map<String, dynamic>> response = await supabase
        .from('tasks')
        .select()
        .eq("group_id", groupId)
        .eq('uni_id', userUniversity)
        .not("task_id", 'in', getTasksUserCreated)
        .not('task_id', 'in', excludedTaskIds);

    return response.map((task) => Task.fromJson(task)).toList();
  } catch (e) {
    print('Error in getAllAvailableTasksFilter: $e');
    return [];
  }
}

/// stvara ulaz u tabelu task_user, sa statusom "doing"
Future<int> createTask(Task task) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final response = await supabase
        .from('tasks')
        .insert({
          // 'task_id': 0, // test value!
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
          'time_for_player': task.timeForPlayer,
        })
        .select('task_id')
        .maybeSingle();

    // 1. postgrest map ne moze u List<Map<String, dynamic>> da se kastuje.
    // 2.

    if (response != null) {
      return response['task_id'];
    } else {
      return -1;
    }
  } catch (e) {
    print('Error in createTask: $e');
    return -1;
  }
}

/////////////////////////////////////////////////////////////// USER_TASKS

/// Gets all tasks with the given STATUS code.   8apr change
Future<List<TaskWithState>> getTaskWithStateWithStatus(
    String nickname, TaskStatus statusId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final List<Map<String, dynamic>> taskIds = await supabase
        .from('user_task')
        .select('task_id')
        .eq('state_id', statusToStringArr[statusId.index])
        .eq('nickname', nickname);

    final List<int> taskIdsList =
        taskIds.map((task) => task['task_id'] as int).toList();

    print(statusToStringArr[statusId.index]);
    print(taskIdsList);

    /// mozda dodaj * ??
    final List<Map<String, dynamic>> response = await supabase
        .from('user_task')
        .select(
            'nickname, state_id,image_evidence,eval_description,tasks(*)') // wish we could format thiiis (wow) to the format i waaa-aant
        .inFilter('task_id', taskIdsList);

    return response
        .map((task) => TaskWithState.fromJoinJson(task, task["tasks"]))
        .toList();
  } catch (e) {
    print('Error in getTaskWithStateWithStatus: $e');
    return [];
  }
}

// todo apr8

Future<List<TaskWithState>> getTaskWithStateToEvaluate(String nickname) async {
  try {
    final statusId = TaskStatus.PENDING; // todo change!
    final supabase = SupabaseHelper.supabase;

    final List<int> tasksCreated = await getTasksCreatedBy(nickname);

    final List<Map<String, dynamic>> response = await supabase
        .from('user_task')
        .select('nickname, state_id,image_evidence,eval_description,tasks(*)')
        .inFilter('task_id', tasksCreated)
        .eq('state_id', statusToStringArr[statusId.index]);

    return response
        .map((task) => TaskWithState.fromJoinJson(task, task["tasks"]))
        .toList();
  } catch (e) {
    print('Error in getTaskWithStateToEvaluate: $e');
    return [];
  }
}

Future<List<TaskWithState>> getTaskWithStateToConfirm(String nickname) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final List<Map<String, dynamic>> response = await supabase
        .from('user_task')
        .select('nickname, state_id,image_evidence,eval_description,tasks(*)')
        .eq('nickname', nickname)
        .inFilter('state_id', [
      statusToStringArr[TaskStatus.ACCEPTED.index],
      statusToStringArr[TaskStatus.DENIED.index],
      statusToStringArr[TaskStatus.PENDING.index],
    ]);

    return response
        .map((task) => TaskWithState.fromJoinJson(task, task["tasks"]))
        .toList();
  } catch (e) {
    print('Error in getTaskWithStateToConfirm: $e');
    return [];
  }
}

// todo apr8

/// stvara ulaz u tabelu task_user, sa statusom "doing", i povecava peopleDoing za 1.
Future<ReturnMessage> createUserTask(String nickname, int taskId) async {
  try {
    final supabase = SupabaseHelper.supabase;
    final response = await supabase.from('user_task').insert({
      'nickname': nickname,
      'task_id': taskId,
      'state_id': statusToStringArr[TaskStatus.DOING.index]
    }); // , 'status': TaskStatus.DOING

    await updateTaskPeopleDoing(taskId, 1);
    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "User task $taskId , $nickname added successfully");
  } catch (e) {
    return ReturnMessage(
        success: false,
        statusCode: 500,
        message: "Exception in createUserTask: $e");
  }
}

// todo warn : Da li ce ovo biti sinhronizacioni problem ako vise usera istovremeno bude radilo stvari?
Future<dynamic> updateTaskPeopleDoingNoRPC(int taskId, int toValue) async {
  try {
    final supabase = SupabaseHelper.supabase;
    final updateDoing = await supabase
        .from('tasks')
        .update({'ppl_doing': toValue}) // Use integer value of enum
        .eq('task_id', taskId); // Ensure both are included

    return updateDoing;
  } catch (e) {
    print("Error in updateTaskPeopleDoing: $e");
    return ReturnMessage(
        success: false,
        statusCode: 500,
        message: "Exception updateTaskPeopleDoing: $e");
  }
}

Future<dynamic> updateTaskPeopleDoing(int taskId, int amount) async {
  try {
    final supabase = SupabaseHelper.supabase;
    final updateSubmitted = await supabase.rpc('increment_ppl_doing',
        params: {'given_task_id': taskId, 'amount': amount});
    return updateSubmitted;
  } catch (e) {
    print("Error in updateTaskPeopleDoing: $e");
    return ReturnMessage(
        success: false,
        statusCode: 500,
        message: "Exception in updateTaskPeopleDoing: $e");
  }
}

Future<dynamic> updateTaskPeopleSubmitted(int taskId, int amount) async {
  try {
    final supabase = SupabaseHelper.supabase;
    final updateSubmitted = await supabase.rpc('increment_ppl_submitted',
        params: {'given_task_id': taskId, 'amount': amount});
    return updateSubmitted;
  } catch (e) {
    print("Error in updateTaskPeopleDoing: $e");
    return ReturnMessage(
        success: false,
        statusCode: 500,
        message: "Exception in updateTaskPeopleSubmitted: $e");
  }
}

// apr 9 todo

// Future<ReturnMessage> approveTaskCompletion() async {

// }

Future<ReturnMessage> acceptUserTask(
    {required String nickname,
    required int taskId,
    required String evalDescription}) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // Then create the task-user relationship
    final response = await supabase.from('user_task').update({
      'state_id': statusToStringArr[TaskStatus.ACCEPTED.index],
      'eval_description': evalDescription
    }) // Use integer value of enum
        .match({
      'task_id': taskId,
      'nickname': nickname
    }); // Ensure both are included

    // await updateTaskPeopleSubmitted(taskId, -1);
    // people completed todo???

    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "acceptUserTask submitted successfully");
  } catch (e) {
    print("Error in acceptUserTask: $e");
    return ReturnMessage(
        success: false,
        statusCode: 500,
        message: "Exception in acceptUserTask: $e");
  }
}

Future<ReturnMessage> denyUserTask(
    {required String nickname,
    required int taskId,
    required String evalDescription}) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // Then create the task-user relationship
    final response = await supabase.from('user_task').update({
      'state_id': statusToStringArr[TaskStatus.DENIED.index],
      'eval_description': evalDescription
    }) // Use integer value of enum
        .match({
      'task_id': taskId,
      'nickname': nickname
    }); // Ensure both are included

    await updateTaskPeopleSubmitted(taskId, -1);
    // people completed todo???

    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "denyUserTask submitted successfully");
  } catch (e) {
    print("Error in denyUserTask: $e");
    return ReturnMessage(
        success: false,
        statusCode: 500,
        message: "Exception in denyUserTask: $e");
  }
}

Future<ReturnMessage> submitUserTask(
    {required String nickname,
    required int taskId,
    required File imageEvidence}) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // upload the photo first
    final photoUrl = await uploadPhotoToSupabase(imageEvidence);
    if (photoUrl == null) {
      return ReturnMessage(
          success: false,
          statusCode: 500,
          message: "error in submitUserTask: photo url is null.");
    }

    // Then create the task-user relationship
    final response = await supabase.from('user_task').update({
      'state_id': statusToStringArr[TaskStatus.PENDING.index],
      'image_evidence': photoUrl
    }) // Use integer value of enum
        .match({
      'task_id': taskId,
      'nickname': nickname
    }); // Ensure both are included

    await updateTaskPeopleDoing(taskId, -1);
    await updateTaskPeopleSubmitted(taskId, 1);

    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "UserTask submitted successfully");
  } catch (e) {
    print("Error in submitUserTask: $e");
    return ReturnMessage(
        success: false,
        statusCode: 500,
        message: "Exception in submitUserTask: $e");
  }
}

Future<String?> uploadPhotoToSupabase(File imageFile) async {
  try {
    final supabase = SupabaseHelper.supabase;
    final fileName = path.basename(imageFile.path);
    final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_$fileName';

    // Upload the file to Supabase storage
    final response = await supabase.storage
        .from(TASKCOMPLETIONS_BUCKET_NAME) // Replace with your bucket name
        .upload(
          uniqueFileName,
          imageFile,
          fileOptions: const FileOptions(
            cacheControl: '3600',
            upsert: false,
          ),
        );

    // Get the public URL of the uploaded file
    final String publicUrl = supabase.storage
        .from(TASKCOMPLETIONS_BUCKET_NAME)
        .getPublicUrl(uniqueFileName);

    return publicUrl;
  } catch (e) {
    print('Error in uploadPhotoToSupabase: $e');
    return null;
  }
}

/// Update user task to given status. if updating to submitted -> update ppl_submitted
Future<ReturnMessage> UpdateUserTaskStatus(
    String nickname, int taskId, TaskStatus newStatusId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    if (!TaskStatus.values.contains(newStatusId)) {
      return ReturnMessage(
          success: false,
          statusCode: 400,
          message: "Invalid status given: $newStatusId");
    }

    final response = await supabase.from('user_task').update({
      'state_id': statusToStringArr[newStatusId.index]
    }) // Use integer value of enum
        .match({
      'task_id': taskId,
      'nickname': nickname
    }); // Ensure both are included

    if (newStatusId == TaskStatus.PENDING) {
      final response = await updateTaskPeopleSubmitted(taskId, 1);
    }
    if (newStatusId == TaskStatus.DENIED ||
        newStatusId == TaskStatus.ACCEPTED) {
      final response = await updateTaskPeopleSubmitted(taskId, -1);
    }

    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "Task status updated successfully");
  } catch (e) {
    print('Error in updateUserTaskStatus: $e');
    return ReturnMessage(
        success: false,
        statusCode: 500,
        message: "Exception in updateUserTaskStatus: $e");
  }
}

// Should be called when user abandons the task.
Future<ReturnMessage> deleteUserTask(String nickname, int taskId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final response = await supabase.from('user_task').delete().match(
        {'task_id': taskId, 'nickname': nickname}); // Ensure both are included

    // if (response.error != null) {
    //   return ReturnMessage(
    //       success: false,
    //       statusCode: 500,
    //       message: "Database error: ${response.error!.message}");
    // }

    // make it so that one person less is doing the task.
    var updateDoing = await updateTaskPeopleDoing(taskId, -1);

    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "User task $taskId removed successfully");
  } catch (e) {
    print('Error in deleteUserTask: $e');
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
    print('Error in getUserByName: $e');
    return null;
  }
}

Future<ReturnMessage> updateUserXP(String nickname, int amount) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final response = await supabase.rpc('increment_user_xp',
        params: {'given_nickname': nickname, 'amount': amount});

    return ReturnMessage(
        success: true, statusCode: 200, message: "User got XP $amount");
  } catch (e) {
    print('Error in upadteUserXP: $e');
    return ReturnMessage(
        success: false, statusCode: 500, message: "Exception: $e");
  }
}

/////////////// Predetermined tasks !!!

Future<List<Map<String, dynamic>>> getAllPredeterminedTasksForUser(
    String nickname) async {
  try {
    // supa
    final supabase = SupabaseHelper.supabase;

    // get list user groups and add group 0
    List<int> userGroups = await getUserGroups(nickname);

    // get all predetermined tasks with group ids:
    final List<Map<String, dynamic>> response = await supabase
        .from('tasks_predetermined')
        .select()
        .inFilter("can_use", userGroups);

    print("Response from getAllPredeterminedTasks for $nickname : ");
    print("$response");

    return response;
    // return response.map((task) => TaskPredetermined.fromJson(task)).toList();
  } catch (e) {
    print('Error in getAllPredeterminedTasksForUser: $e');
    return [];
  }
}

// getPredeterminedForGroup
Future<List<Map<String, dynamic>>> getPredeterminedForGroup(
    String nickname, int groupId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // check if the user is in the group from which they're asking for tasks
    final List<Map<String, dynamic>> userGroups = await supabase
        .from('user_group')
        .select('group_id')
        .eq('nickname', nickname)
        .eq('group_id', groupId);

    // HOW TO CHECK IF THIS WILL NOT BREAK ??? todo
    if (userGroups.isEmpty) {
      return [];
    }

    // fetch predetermined tasks for group
    final List<Map<String, dynamic>> response = await supabase
        .from('tasks_predetermined')
        .select()
        .eq("can_use", groupId);

    print("Response from getPredeterminedForGroup for $nickname : ");
    print("$response");

    return response;
  } catch (e) {
    print('Error in getPredeterminedForGroup: $e');
    return [];
  }
}

// createDeterminedTask - these tasks can't be changed at all, and contibute towards achievements.
// todo - mozda staviti da je pplNeeded fleksibilno, da se specificira pri pravljenju svakog taska ovog tipa?
// todo - dodati posebne poene (stats)
Future<ReturnMessage> createPredefinedTask(TaskPredetermined task) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final response = await supabase.from('tasks_predetermined').insert({
      'task_id': task.predId,
      'can_use': task.canUse,
      'name': task.name,
      'description': task.description,
      'for_group': task.forGroup,
      'place': task.place,
      'xp': task.xp,
      'urgent': task.urgent,
      'exists_for_time': task.existsForTime,
      'ppl_needed': task.pplNeeded,
      'ppl_doing': task.pplDoing,
      'ppl_submitted': task.pplSubmitted,
    });

    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "Predetermined task '${task.name}' created successfully");
  } catch (e) {
    print('Error in createDeterminedTask: $e');
    return ReturnMessage(
        success: false, statusCode: 500, message: "Exception: $e");
  }
}

// createDeterminedExisting

Future<ReturnMessage> createPredeterminedExisting(
    String nickname, int taskId, int predId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final response = await supabase
        .from('predetermined_existing')
        .insert({'task_id': taskId, 'pred_id': predId});

    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "User task $taskId , $nickname added successfully");
  } catch (e) {
    print('Error in createPredeterminedExisting: $e');
    return ReturnMessage(
        success: false, statusCode: 500, message: "Exception: $e");
  }
}

// deleteDeterminedExisting
Future<ReturnMessage> deleteDeterminedExisting(
    String nickname, int taskId, int predId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final response = await supabase
        .from('predetermined_existing')
        .delete()
        .match(
            {'task_id': taskId, 'pred_id': predId}); // Ensure both are included
    // todo - maybe include some logic for stats/achievements ?

    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "User task $taskId removed successfully");
  } catch (e) {
    print('Error in deleteDeterminedExisting: $e');
    return ReturnMessage(
        success: false, statusCode: 500, message: "Exception: $e");
  }
}

/// Checks if a user is assigned to a specific task
Future<bool> isUserOnTask(
    {required String? user_nickname, required int task_id}) async {
  return false; // todo implement this
}

Future<List<TaskWithUser>> getAllTaskWithUsers() async {
  return []; // todo implement this
}

/// Inserts a new task into the database
Future<bool> insertTask(Task task) async {
  return true;
}

Future<ReturnMessage> userTaskChangeStateToWaitingDelete(
    {required String nickname, required int taskId}) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // Update the task state to "waiting_delete"
    final response = await supabase.from('user_task').update({
      'state_id': statusToStringArr[TaskStatus.WAITING_DELETE.index],
    }).match({
      'task_id': taskId,
      'nickname': nickname,
    });

    return ReturnMessage(
      success: true,
      statusCode: 200,
      message: "Task state changed to 'waiting_delete' successfully",
    );
  } catch (e) {
    print('Error in userTaskChangeStateToWaitingDelete: $e');
    return ReturnMessage(
      success: false,
      statusCode: 500,
      message: "Exception in userTaskChangeStateToWaitingDelete: $e",
    );
  }
}

Future<ReturnMessage> rewardUserForTask({
  required TaskWithState task,
  required String nickname,
}) async {
  try {
    // Update the task state to "rewarded"
    final response = await userTaskChangeStateToWaitingDelete(
      nickname: nickname,
      taskId: task.taskId,
    );

    // Update user XP
    final xpResponse = await updateUserXP(nickname, task.xp);

    // Check if the XP update response contains an error
    if (!xpResponse.success) {
      return ReturnMessage(
        success: false,
        statusCode: 500,
        message: "Failed to update user XP: ${xpResponse.message}",
      );
    }

    return ReturnMessage(
      success: true,
      statusCode: 200,
      message: "Reward claimed successfully!",
    );
  } catch (e) {
    return ReturnMessage(
      success: false,
      statusCode: 500,
      message: "An error occurred: $e",
    );
  }
}

Future<List<Group>> getAllUserGroups(String nickname) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // Fetch all group IDs the user is a part of
    final List<Map<String, dynamic>> userGroups = await supabase
        .from('user_group')
        .select('group_id')
        .eq('nickname', nickname);

    // Extract group IDs
    final List<int> groupIds =
        userGroups.map((group) => group['group_id'] as int).toList();

    // Fetch group details for the group IDs
    final List<Map<String, dynamic>> response = await supabase
        .from('groups')
        .select()
        .inFilter('group_id', groupIds); // Use inFilter instead of in_

    // Map the response to a list of Group objects
    return response.map((group) => Group.fromJson(group)).toList();
  } catch (e) {
    print('Error in getAllUserGroups: $e');
    return [];
  }
}

Future<List<Group>> getAllGroupsExceptUserGroups(String nickname) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // Fetch all group IDs the user is a part of
    final List<Map<String, dynamic>> userGroups = await supabase
        .from('user_group')
        .select('group_id')
        .eq('nickname', nickname);

    // Extract group IDs
    final List<int> groupIds =
        userGroups.map((group) => group['group_id'] as int).toList();

    // Fetch all groups excluding the ones the user is a part of
    final List<Map<String, dynamic>> response =
        await supabase.from('groups').select().not('group_id', 'in', groupIds);

    // Map the response to a list of Group objects
    return response.map((group) => Group.fromJson(group)).toList();
  } catch (e) {
    print('Error in getAllGroupsExceptUserGroups: $e');
    return [];
  }
}

Future<List<UserModel>> getTopPlayersByXP(int universityId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // Query the database to get the top 7 players by XP for the given university_id
    final List<Map<String, dynamic>> response = await supabase
        .from('users') // Assuming the table is named 'users'
        .select(
            'nickname, xp, image') // Select all fields required for UserModel
        .eq('uni_id', universityId) // Filter by university_id
        .order('xp', ascending: false) // Order by XP in descending order
        .limit(7); // Limit the results to the top 7

    // Print the response for debugging purposes
    // Map the response to a list of UserModel objects
    return response.map((data) => UserModel.fromJson(data)).toList();
  } catch (e) {
    print('Error in getTopPlayersByXP: $e');
    return [];
  }
}

Future<List<UserModel>> getGroupMembers(int groupId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // Query the database to get all members of the group
    final List<Map<String, dynamic>> response = await supabase
        .from('user_group') // Assuming the table is named 'user_group'
        .select('nickname, users(xp, image)') // Join with the 'users' table
        .eq('group_id', groupId);

    // Map the response to a list of UserModel objects
    return response.map((data) {
      final user = data['users'];
      return UserModel(
        nickname: data['nickname'],
        xp: user['xp'] ?? 0,
        image: user['image'],
      );
    }).toList();
  } catch (e) {
    print('Error in getGroupMembers: $e');
    return [];
  }
}

Future<bool> kickMemberFromGroup(String nickname, int groupId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // Delete the user from the user_group table
    final response = await supabase
        .from('user_group')
        .delete()
        .match({'nickname': nickname, 'group_id': groupId});

    return true;
  } catch (e) {
    print('Error in kickMemberFromGroup: $e');
    return false;
  }
}

Future<bool> acceptJoinRequest(String nickname, int groupId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // Add the user to the user_group table
    final response = await supabase.from('user_group').insert({
      'nickname': nickname,
      'group_id': groupId,
      'role': 'user', // Default role for new members
    });

    if (response.error != null) {
      print('Error in acceptJoinRequest: ${response.error!.message}');
      return false;
    }

    // Remove the join request from the group_join_request table
    await supabase
        .from('group_join_request')
        .delete()
        .match({'nickname': nickname, 'group_id': groupId});

    return true;
  } catch (e) {
    print('Error in acceptJoinRequest: $e');
    return false;
  }
}

Future<bool> denyJoinRequest(String nickname, int groupId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // Remove the join request from the group_join_request table
    final response = await supabase
        .from('group_join_request')
        .delete()
        .match({'nickname': nickname, 'group_id': groupId});

    if (response.error != null) {
      print('Error in denyJoinRequest: ${response.error!.message}');
      return false;
    }

    return true;
  } catch (e) {
    print('Error in denyJoinRequest: $e');
    return false;
  }
}

Future<List<GroupJoinRequest>> getGroupJoinRequests(int groupId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // Query the database to get all join requests for the group
    final List<Map<String, dynamic>> response = await supabase
        .from(
            'group_join_request') // Assuming the table is named 'group_join_request'
        .select('nickname, group_id') // Select the required fields
        .eq('group_id', groupId); // Filter by group_id

    // Map the response to a list of GroupJoinRequest objects
    return response.map((data) => GroupJoinRequest.fromJson(data)).toList();
  } catch (e) {
    print('Error in getGroupJoinRequests: $e');
    return [];
  }
}

Future<List<UserModel>> getUsersGroupJoinRequests(int groupId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // Query the database to get all join requests for the group and join with the users table
    final List<Map<String, dynamic>> response = await supabase
        .from(
            'group_join_request') // Assuming the table is named 'group_join_request'
        .select('nickname, users(xp, image)') // Join with the 'users' table
        .eq('group_id', groupId); // Filter by group_id

    // Map the response to a list of UserModel objects
    return response.map((data) {
      final user = data['users'];
      return UserModel(
        nickname: data['nickname'],
        xp: user['xp'] ?? 0,
        image: user['image'],
      );
    }).toList();
  } catch (e) {
    print('Error in getUsersGroupJoinRequests: $e');
    return [];
  }
}

Future<bool> joinGroup(String nickname, int groupId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // Insert the user into the user_group table
    final response = await supabase.from('user_group').insert({
      'nickname': nickname,
      'group_id': groupId,
      'role': 'user', // Default role for new members
    });

    if (response.error != null) {
      print('Error in joinGroup: ${response.error!.message}');
      return false;
    }

    return true;
  } catch (e) {
    print('Error in joinGroup: $e');
    return false;
  }
}

/// achievements apr 13

Future<List<AchWithUser>> getAchievementsWithUser(String nickname) async {
  // get all achievements, if they arent in ach_user set their win and claimed to false, else read claimed from user_ach
  // how to write this query?

  // for given user fetch all stat points and return them as a list of StatPoint objects
  try {
    final supabase = SupabaseHelper.supabase;

    // Query the database to get all stat points for user joined with point name
    final List<Map<String, dynamic>> response = await supabase
        .from('user_achievement')
        .select('claim_award, achievements(*)')
        .eq('nickname', nickname);

    List<AchWithUser> userWonAch =
        response.map((data) => AchWithUser.fromUserAchJson(data)).toList();

    print(" get achievements of user : $response");

    // Extract only the achId fields from userWonAch
    List<int> wonAchIds = userWonAch.map((ach) => ach.achId).toList();

    final List<Map<String, dynamic>> userNotWonAch = await supabase
        .from('achievements')
        .select()
        .not('ach_id', 'in', wonAchIds); // Use the list of achId fields

    print(" get all achievements not user : $userNotWonAch");

    userWonAch.addAll(userNotWonAch
        .map((data) => AchWithUser.fromAchNotWonJson(data))
        .toList());

    return userWonAch;
    // Map the response to a list of UserModel objects
  } catch (e) {
    print('Error in getAchievementsWithUser: $e');
    return [];
  }
}

void checkEarnedAchievements() async {
  // for the just updated skill point (or level?) from user
  // check if it matches any achievement criteria
  // and if the achievement is not already won
  // insert it into user_ach table, with "not_claimed".
}

Future<AchWithUser?> updateUserAchEarn(String nickname, int achId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final response = await supabase
        .from('user_achievements')
        .insert({
          // 'task_id': 0, // test value!
          'nickname': nickname,
          'ach_id': achId,
        })
        .select('achievement(*)')
        .maybeSingle();

    print("response from updateUserAchEarn $response");

    if (response != null) {
      return AchWithUser.fromAchNotWonJson(response);
    } else {
      print("updateUserAchEarn returned null");
    }
  } catch (e) {
    print('Error in createTask: $e');
    return null;
  }
}

Future<ReturnMessage> updateClaimAchievement(
    {required String nickname, required int achId, required int amount}) async {
  // set user_ach to "claimed
  try {
    final supabase = SupabaseHelper.supabase;

    // Then create the task-user relationship
    final response = await supabase.from('user_achievements').update({
      'claim_award': true,
    }) // Use integer value of enum
        .match({
      'nickname': nickname,
      'ach_id': achId
    }); // Ensure both are included

    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "updateClaimAchievement submitted successfully");
  } catch (e) {
    print("Error in updateClaimAchievement: $e");
    return ReturnMessage(
        success: false,
        statusCode: 500,
        message: "Exception in updateClaimAchievement: $e");
  }
}

/// skill points apr13

Future<List<StatPoint>> getUserStats(String nickname) async {
  // for given user fetch all stat points and return them as a list of StatPoint objects
  try {
    final supabase = SupabaseHelper.supabase;

    // Query the database to get all stat points for user joined with point name
    final List<Map<String, dynamic>> response = await supabase
        .from('user_stats')
        .select('*, stat_points(name)')
        .eq('nickname', nickname);

    // Map the response to a list of UserModel objects
    return response.map((data) => StatPoint.fromJson(data)).toList();
  } catch (e) {
    print('Error in getUserStats: $e');
    return [];
  }
}

Future<ReturnMessage> updateStatPoint(
    {required String nickname,
    required int statId,
    required int amount}) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // Then create the task-user relationship
    final response = await supabase.from('user_stats').update({
      'amount': amount,
    }) // Use integer value of enum
        .match({
      'nickname': nickname,
      'stat_id': statId
    }); // Ensure both are included

    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "updateStatPoint submitted successfully");
  } catch (e) {
    print("Error in updateStatPoint: $e");
    return ReturnMessage(
        success: false,
        statusCode: 500,
        message: "Exception in updateStatPoint: $e");
  }
}




// implementirati sad da koriste nickname svi, pa posle menjati kako radi API i tabele i FK-eve. 
// todo:
// 1. init user_ach i user_stats da koriste nickname
// 2. napraviti ove API pozive gore ^^^
// 3. napraviti funkcije koje dohvataju te podatke
// 4. iskoristiti ih u futurebuilderu ili tako nesto??

