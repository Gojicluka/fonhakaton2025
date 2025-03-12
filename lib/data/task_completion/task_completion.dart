import 'dart:io';
import 'package:fonhakaton2025/data/global.dart';
import 'package:fonhakaton2025/data/models/task.dart';
import 'package:fonhakaton2025/data/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

final String TASKCOMPLETIONS_BUCKET_NAME = "taskcompletions";

Future<String?> uploadPhotoToSupabase(File imageFile) async {
  try {
    final supabase = Supabase.instance.client;
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
    print('Error uploading image: $e');
    return null;
  }
}

Future<bool> submitTaskCompletion({
  required File imageFile,
  required int taskId,
  required int userId,
  String? description,
}) async {
  // First upload the photo
  final photoUrl = await uploadPhotoToSupabase(imageFile);
  if (photoUrl == null) return false;

  // Then create the task-user relationship
  return await SupabaseHelper.addUserToTask(
    taskId: taskId,
    userId: userId,
    photo: photoUrl,
    description: description,
  );
}

Future<bool> approveTaskCompletion({
  required int taskId,
  required int userId,
}) async {
  Task? task = await SupabaseHelper.getTaskById(taskId);
  if (task == null) return false;

  if (task.peopleNeeded == 1) {
    await SupabaseHelper.updateTask(
      taskId: taskId,
      peopleNeeded: 0,
      peopleApplied: 0,
      done: true,
    );
  } else {
    await SupabaseHelper.updateTask(
      taskId: taskId,
      peopleNeeded: task.peopleNeeded - 1,
      peopleApplied: task.peopleApplied - 1,
    );
  }

  await SupabaseHelper.updateUserXP(
      userId: userId, xpAmount: Global.user!.xp + task.xpGain);

  return await SupabaseHelper.updateTaskUserStatus(
    taskId: taskId,
    userId: userId,
    approved: true,
    denied: false,
  );
}

Future<bool> denyTaskCompletion({
  required int taskId,
  required int userId,
}) async {
  return await SupabaseHelper.updateTaskUserStatus(
    taskId: taskId,
    userId: userId,
    approved: false,
    denied: true,
  );
}
