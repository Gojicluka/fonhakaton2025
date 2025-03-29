import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonhakaton2025/data/global.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:fonhakaton2025/data/models/task_with_user.dart';

// final pendingTaskProvider =
//     StateNotifierProvider<PendingTaskNotifier, List<TaskWithUser>>(
//   (ref) => PendingTaskNotifier(),
// );

// class PendingTaskNotifier extends StateNotifier<List<TaskWithUser>> {
//   PendingTaskNotifier() : super([]) {
//     fetchPendingTasks();
//     listenForTaskUpdates();
//   }

//   bool isVisible = true;

//   void toggleVisibility() {
//     isVisible = !isVisible;
//   }

//   /// Fetch tasks created by the current user that are pending approval
//   Future<void> fetchPendingTasks() async {
//     final userId = Global.user!.id;

//     final response = await Supabase.instance.client
//         .from('task_users')
//         .select('''
//       task_id,
//       tasks:task_id (
//         id, creator_id, title, description, done, people_needed, 
//         is_public, student_group_id, university_id, location, 
//         xp_gain, duration_minutes, people_applied, color, icon
//       ),
//       user_id, photo, description, approved, denied
//     ''')
//         .eq('tasks.creator_id', userId) // Only tasks the user created
//         .eq("approved", false) // Not yet approved
//         .eq('denied', false) // Not yet denied
//         .order('task_id', ascending: false);

//     state = (response as List<dynamic>)
//         .map((task) => TaskWithUser.fromMap(task))
//         .toList();
//   }

//   /// Listen for real-time updates when tasks get added or updated
//   void listenForTaskUpdates() {
//     Supabase.instance.client
//         .from('task_users')
//         .stream(primaryKey: ['task_id', 'user_id']).listen((data) {
//       fetchPendingTasks(); // Refresh the list
//     });
//   }
// }
