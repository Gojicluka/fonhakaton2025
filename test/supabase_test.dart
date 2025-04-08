import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fonhakaton2025/data/databaseAPI/supabaseAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';

// todo - assertions?

void main() {
  setUpAll(() async {
    print("Loading");
    print("Initializing Supabase...");

    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    await dotenv.load();
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_KEY']!,
    );
  });

  String username = "test";

  test('Fetch all available tasks for user', () async {
    final response = await getAllAvailableTasks(username);

    print('Fetched tasks: $response');

    for (var task in response) {
      print('Task name: ${task.name}');
    }

    expect(response, isNotEmpty);
  });

  test('Fetch all global available for user', () async {
    final response =
        await getAllAvailableTasksFilter(username, Groups.NOGROUP as int);
    print('Fetched tasks: $response');

    for (var task in response) {
      print('Task name: ${task.name}');
    }

    expect(response, isNotEmpty);
  });

  test('Fetch doing tasks for user', () async {
    final response =
        await getTaskWithStateWithStatus(username, TaskStatus.DOING);

    print('Fetched doing tasks: $response');

    for (var task in response) {
      print(task.name);
    }

    expect(response, isNotEmpty);
  });

  // test('Fetch user profile data', () async {
  //   final response = await getUserProfile(username);

  //   print('Fetched user profile: $response');

  //   expect(response, isNotNull);
  //   expect(response.username, equals(username));
  // });

  test('Update task status to PENDING for user', () async {
    final taskId = 0; // Example task ID
    final response =
        await UpdateUserTaskStatus(username, taskId, TaskStatus.PENDING);

    print('Updated task status: $response');

    expect(response, isTrue);
  });

  test('Delete a task for user', () async {
    final taskId = 0; // Example task ID
    final response = await deleteUserTask(username, taskId);

    print('Deleted task response: $response');

    // promeni matcher VV todo
    expect(response, isTrue);
  });
}
