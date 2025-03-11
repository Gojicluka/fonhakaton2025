import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:fonhakaton2025/data/models.dart";

Future<void> init_supabase() async {
  print("Loading");
  print("Initializing Supabase...");
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );
}

class SupabaseHelper {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<UserModel?> getUserByName(String name) async {
    try {
      final response = await _supabase
          .from('users')
          .select('*')
          .eq('name', name)
          .maybeSingle();

      if (response == null) return null;
      return UserModel.fromJson(response);
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }
}
