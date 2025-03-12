import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonhakaton2025/data/global.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Map<String, dynamic>>>(
  (ref) => TaskNotifier(),
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
    final userId = Global.user!.id;
    final response = await Supabase.instance.client
        .from('tasks')
        .select('*')
        .eq('done', false) // Only fetch undone tasks
        .not(
            'id',
            'in',
            (query) =>
                query.from('task_users').select('TaskId').eq('UserId', userId))
        .order('id', ascending: false);
    state = response;
  }

  /// Listen for new tasks in real-time
  void listenForNewTasks() {
    Supabase.instance.client
        .from('tasks')
        .stream(primaryKey: ['id']).listen((data) {
      fetchTasks(); // Refresh task list when a new task is added
    });
  }
}
