import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonhakaton2025/data/databaseAPI/supabaseAPI.dart';
import 'package:fonhakaton2025/data/global.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final predeterminedTaskProvider = StateNotifierProvider<
    PredeterminedTaskNotifier, List<Map<String, dynamic>>>(
  (ref) => PredeterminedTaskNotifier(),
);

class PredeterminedTaskNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {
  PredeterminedTaskNotifier() : super([]) {
    fetchTasks();
    listenForNewTasks();
  }
  bool isVisible = true;

  void toggleVisibility() {
    isVisible = !isVisible;
  }

  /// Fetch all undone tasks from Supabase excluding ones the user has applied to
  Future<void> fetchTasks() async {
    final response =
        await getAllPredeterminedTasksForUser(Global.getUsername());
    state = response;
  }

  /// Listen for new tasks in real-time
  void listenForNewTasks() {
    Supabase.instance.client
        .from('tasks')
        .stream(primaryKey: ['task_id']).listen((data) {
      fetchTasks(); // will this be async?
    });

    //  .listen((List<Map<String, dynamic>> data) {
    //       if (data.isNotEmpty) {
    //         final updatedUser = UserModel.fromJson(data.first);
    //         Global.setUser(updatedUser); // Keep Global in sync
    //         state = updatedUser;
    //       }
    //     });
  }
}
