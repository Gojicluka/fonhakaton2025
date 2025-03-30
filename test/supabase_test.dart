import 'package:fonhakaton2025/data/models/task.dart';
import 'package:test/test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:fonhakaton2025/data/models/task.dart';
// import 'package:fonhakaton2025/data/models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fonhakaton2025/data/databaseAPI/supabaseAPI.dart';
// import 'package:flutter/material.dart';

void main() {
  setUpAll(() async {
    print("Loading");
    print("Initializing Supabase...");
    await dotenv.load();
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_KEY']!,
    );
  });

  test('Fetch all available tasks for user', () async {
    // final supabase = Supabase.instance.client;
    // final response = await supabase.from('users').select();

    String username = "test";

    final Future<List<Task>> response = getAllAvailableTasks(username);

    print('Fetched tasks: $response');

    expect(response, isNotEmpty);
  });
}
