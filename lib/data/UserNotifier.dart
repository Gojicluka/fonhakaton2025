import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonhakaton2025/data/global.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fonhakaton2025/data/models/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(Global.user) {
    // Initialize with current user from Global
    fetchUser();
    listenToUserChanges();
  }

  Future<void> fetchUser() async {
    if (Global.user == null) return;

    try {
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', Global.user!.id)
          .single();

      if (response != null) {
        final updatedUser = UserModel.fromJson(response);
        Global.setUser(updatedUser); // Keep Global in sync
        state = updatedUser;
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  void listenToUserChanges() {
    if (Global.user == null) return;

    Supabase.instance.client
        .from('users')
        .stream(primaryKey: ['id'])
        .eq('id', Global.user!.id)
        .listen((List<Map<String, dynamic>> data) {
          if (data.isNotEmpty) {
            final updatedUser = UserModel.fromJson(data.first);
            Global.setUser(updatedUser); // Keep Global in sync
            state = updatedUser;
          }
        });
  }

  // Update user XP (example method)
  Future<void> updateUserXP(int newXP) async {
    if (state == null) return;

    try {
      await Supabase.instance.client
          .from('users')
          .update({'xp': newXP}).eq('id', state!.id);

      // The listener will automatically update the state
    } catch (e) {
      print('Error updating user XP: $e');
    }
  }
}
