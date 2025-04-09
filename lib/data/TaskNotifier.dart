import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonhakaton2025/data/databaseAPI/supabaseAPI.dart';
import 'package:fonhakaton2025/data/global.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Map<String, dynamic>>>(
  (ref) => TaskNotifier(),
);

final takenTaskProvider =
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
    // changed to use API function.

    // is a dynamic map <string,dynamic>
    final response = await getAllAvailableTasks(Global.getUsername());

    // final response = await Supabase.instance.client
    //     .from('tasks')
    //     .select('*')        // .not('id', 'in',
    //     //     '(SELECT COALESCE((SELECT task_id FROM task_users WHERE user_id = $userId), 0))')
    //     .order('task_id', ascending: false);
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
