import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonhakaton2025/data/databaseAPI/supabaseAPI.dart';
import 'package:fonhakaton2025/data/global.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fonhakaton2025/data/models/task.dart';

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>(
  (ref) => TaskNotifier(),
);

final groupTaskProvider =
    StateNotifierProvider<GroupTaskNotifier, List<Task>>(
  (ref) => GroupTaskNotifier(),
);

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]) {
    fetchTasks();
    listenForNewTasks();
  }
  bool isVisible = true;

  void toggleVisibility() {
    isVisible = !isVisible;
  }

  /// Fetch all undone tasks from Supabase excluding ones the user has applied to
  Future<void> fetchTasks() async {
    final response = await getAllGlobalTasks(Global.getUsername());
    state = response;
  }

  /// Listen for new tasks in real-time
  void listenForNewTasks() {
    Supabase.instance.client
        .from('tasks')
        .stream(primaryKey: ['task_id']).listen((data) {
      fetchTasks(); // Refresh task list when a new task is added
    });
  }
}

class GroupTaskNotifier extends TaskNotifier {
  @override
  Future<void> fetchTasks() async {
    final response = await getAllGroupTasks(Global.getUsername());
    state = response;
  }
}
