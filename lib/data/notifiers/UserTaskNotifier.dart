// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonhakaton2025/data/databaseAPI/supabaseAPI.dart';
import 'package:fonhakaton2025/data/global.dart';
import 'package:fonhakaton2025/data/models/combined/taskWithState.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final doingTaskProvider =
    StateNotifierProvider<UserDoingNotifier, List<TaskWithState>>(
  (ref) => UserDoingNotifier(),
);

final evalTaskProvider =
    StateNotifierProvider<UserEvaluateNotifier, List<TaskWithState>>(
  (ref) => UserEvaluateNotifier(),
);

final confirmTaskProvider =
    StateNotifierProvider<UserConfirmNotifier, List<TaskWithState>>(
  (ref) => UserConfirmNotifier(),
);

class UserDoingNotifier extends StateNotifier<List<TaskWithState>> {
  UserDoingNotifier() : super([]) {
    fetchData();
    listenForChanges();
  }
  bool isVisible = true;

  void toggleVisibility() {
    isVisible = !isVisible;
  }

  /// fetch List<TaskWithState> of tasks the current user is currently doing.
  Future<void> fetchData() async {
    final response = await getTaskWithStateWithStatus(
        Global.getUsername(), TaskStatus.DOING);
    state = response;
    print("userdoingnotifier fetch data:  $state");
  }

  // Listen for new tasks in real-time
  void listenForChanges() {
    Supabase.instance.client
        .from('user_task')
        .stream(primaryKey: ['task_id', 'nickname']).listen((data) {
      print("fetch data for doing");
      fetchData(); // Refresh task list when a new task is added
    });
  }
}

class UserEvaluateNotifier extends StateNotifier<List<TaskWithState>> {
  UserEvaluateNotifier() : super([]) {
    fetchData();
    listenForChanges();
  }
  bool isVisible = true;

  void toggleVisibility() {
    isVisible = !isVisible;
  }

  /// fetch List<TaskWithState> of tasks the current user should evaluate (is owner of those tasks).
  Future<void> fetchData() async {
    final response = await getTaskWithStateToEvaluate(Global.getUsername());

    state = response;
  }

  /// Listen for new tasks in real-time
  void listenForChanges() {
    Supabase.instance.client
        .from('user_task')
        .stream(primaryKey: ['task_id', 'nickname']).listen((data) {
      fetchData(); // Refresh task list when a new task is added
    });
  }
}

class UserConfirmNotifier extends StateNotifier<List<TaskWithState>> {
  UserConfirmNotifier() : super([]) {
    fetchData();
    listenForChanges();
  }
  bool isVisible = true;

  void toggleVisibility() {
    isVisible = !isVisible;
  }

  /// fetch List<TaskWithState> of tasks the current user should evaluate (is owner of those tasks).
  Future<void> fetchData() async {
    final response = await getTaskWithStateToConfirm(Global.getUsername());

    state = response;
  }

  // Listen for new tasks in real-time
  void listenForChanges() {
    Supabase.instance.client
        .from('user_task')
        .stream(primaryKey: ['task_id', 'nickname']).listen((data) {
      fetchData(); // Refresh task list when a new task is added
    });
  }
}
