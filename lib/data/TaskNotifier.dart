import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonhakaton2025/data/databaseAPI/supabaseAPI.dart';
import 'package:fonhakaton2025/data/global.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Map<String, dynamic>>>(
  (ref) => TaskNotifier(),
);

final groupTaskProvider =
    StateNotifierProvider<GroupTaskNotifier, List<Map<String, dynamic>>>(
  (ref) => GroupTaskNotifier(),
);

class TaskNotifier extends StateNotifier<List<Map<String, dynamic>>> {
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
    final response = await getAllAvailableTasks(Global.getUsername());
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
    // final response = await getAllAvailableTasksFilter(Global.getUsername(), 0);
    // state = response;
  }
}
