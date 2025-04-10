import 'dart:io';
import 'package:fonhakaton2025/data/models/TasksPredetermined.dart';
import 'package:fonhakaton2025/data/models/combined/taskWithUser.dart';
import 'package:fonhakaton2025/data/models/task.dart';
import 'package:fonhakaton2025/data/models/combined/taskWithState.dart';
import 'package:fonhakaton2025/data/models/user.dart';
import 'package:fonhakaton2025/data/supabase_helper.dart';
// import 'package:postgrest/src/types.dart';
import 'package:supabase/src/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

//////// STRUCTURES

// todo: make it match the ID-s in database.
// waiting_delete -> taskovi koji su prihvaceni i nagradjeni, ne vide se nigde, ali se brisu tek kada se obrise glavni task iz kog su nastali,
// kako ne bi jedan user mogao da radi isti quest vise puta!
enum TaskStatus { DOING, PENDING, ACCEPTED, DENIED, WAITING_DELETE }

enum Groups { NOGROUP, ADDMORE }

// bucket names for storage
final String TASKCOMPLETIONS_BUCKET_NAME = "taskcompletions";

List<String> statusToStringArr = [
  "doing",
  "pending",
  "accepted",
  "denied",
  "waiting_delete"
];

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
Future<List<Map<String, dynamic>>> getAllAvailableTasks(String nickname) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // Fetch task_ids associated with the given nickname - both taken quests and made quests.
    List<int> excludedTaskIds = await getUserTaskIds(nickname);
    List<int> getTasksUserCreated = await getTasksCreatedBy(nickname);
    int userUniversity = await getUserUniversity(nickname);

    print("excluded task ids $excludedTaskIds");
    print("user created ids $getTasksUserCreated");

    // fetch user groups as a list
    final List<Map<String, dynamic>> userGroups = await supabase
        .from('user_group')
        .select('group_id')
        .eq('nickname', nickname);

    final List<int> userGroupsList =
        userGroups.map((task) => task['group_id'] as int).toList();
    userGroupsList.add(Groups.NOGROUP.index);

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
    return response;
  } catch (e) {
    print('Error in getAllAvailableTasks: $e');
    return [];
  }
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
Future<ReturnMessage> createTask(Task task) async {
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

    return ReturnMessage(
        success: true,
        statusCode: 200,
        message: "Task '${task.name}' created successfully");
  } catch (e) {
    print('Error in createTask: $e');
    return ReturnMessage(
        success: false, statusCode: 500, message: "Exception: $e");
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
    // if (response == null || response.error != null) {
    //   return ReturnMessage(
    //       success: false,
    //       statusCode: 500,
    //       message: "Database error: ${response.error!.message}");
    // }
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

    // if (response.error != null) {
    //   return ReturnMessage(
    //       success: false,
    //       statusCode: 500,
    //       message: "Database error: ${response.error!.message}");
    // }

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

    // if (response.error != null) {
    //   return ReturnMessage(
    //       success: false,
    //       statusCode: 500,
    //       message: "Database error: ${response.error!.message}");
    // }

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

    // if (response.error != null) {
    //   return ReturnMessage(
    //       success: false,
    //       statusCode: 500,
    //       message: "Database error: ${response.error!.message}");
    // }

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

    if (response.error != null) {
      return ReturnMessage(
          success: false,
          statusCode: 500,
          message: "Database error: ${response.error!.message}");
    }

    if (newStatusId == TaskStatus.PENDING) {
      final response = await updateTaskPeopleSubmitted(taskId, 1);
      if (response.error != null) {
        print("nooo");
      }
    }
    if (newStatusId == TaskStatus.DENIED ||
        newStatusId == TaskStatus.ACCEPTED) {
      final response = await updateTaskPeopleSubmitted(taskId, -1);
      if (response.error != null) {
        print("nooo");
      }
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
    if (response.error != null) {
      return ReturnMessage(
          success: false,
          statusCode: 500,
          message: "Database error: ${response.error!.message}");
    }

    return ReturnMessage(
        success: true, statusCode: 200, message: "User got XP $amount");
  } catch (e) {
    print('Error in upadteUserXP: $e');
    return ReturnMessage(
        success: false, statusCode: 500, message: "Exception: $e");
  }
}

/////////////// Predetermined tasks !!!

// getPredeterminedForGroup
Future<List<TaskPredetermined>> getPredeterminedForGroup(
    String nickname, int groupId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    // check if the user is in the group from which they're asking for tasks
    // final List<Map<String, dynamic>> userGroups = await supabase
    //     .from('user_group')
    //     .select('group_id')
    //     .eq('nickname', nickname)
    //     .eq('group_id', groupId);

    // // HOW TO CHECK IF THIS WILL NOT BREAK ??? todo
    // if (userGroups.isEmpty) {
    //   return [];
    // }

    // fetch predetermined tasks for group
    final List<Map<String, dynamic>> response = await supabase
        .from('tasks_predetermined')
        .select()
        .eq("group_id", groupId);

    return response.map((task) => TaskPredetermined.fromJson(task)).toList();
  } catch (e) {
    print('Error in getPredeterminedForGroup: $e');
    return [];
  }
}

// createDeterminedTask - these tasks can't be changed at all, and contibute towards achievements.
// todo - mozda staviti da je pplNeeded fleksibilno, da se specificira pri pravljenju svakog taska ovog tipa?
// todo - dodati posebne poene (stats)
Future<ReturnMessage> createDeterminedTask(TaskPredetermined task) async {
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

    if (response.error != null) {
      return ReturnMessage(
          success: false,
          statusCode: 500,
          message: "Database error: ${response.error!.message}");
    }
    ;

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

Future<ReturnMessage> createDeterminedExisting(
    String nickname, int taskId, int predId) async {
  try {
    final supabase = SupabaseHelper.supabase;

    final response = await supabase
        .from('predetermined_existing')
        .insert({'task_id': taskId, 'pred_id': predId});
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
    print('Error in createDeterminedExisting: $e');
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

    if (response.error != null) {
      return ReturnMessage(
          success: false,
          statusCode: 500,
          message: "Database error: ${response.error!.message}");
    }

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
