import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  /// Fetch all tasks from Supabase
  Future<void> fetchTasks() async {
    final response = await Supabase.instance.client
        .from('tasks')
        .select('*')
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
