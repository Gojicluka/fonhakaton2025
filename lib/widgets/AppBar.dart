import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/rendering.dart';
import 'package:fonhakaton2025/data/notifiers/UserNotifier.dart';
import 'package:fonhakaton2025/data/notifiers/PredeterminedTaskProvider.dart';
import 'package:fonhakaton2025/screens/ProfileScreen.dart';
import 'package:fonhakaton2025/data/models/user.dart';
import 'package:fonhakaton2025/screens/HelpScreen.dart';
import 'package:fonhakaton2025/data/Global.dart';

final xpAnimationProvider =
    StateNotifierProvider<XpAnimationNotifier, bool>((ref) {
  return XpAnimationNotifier();
});

class XpAnimationNotifier extends StateNotifier<bool> {
  int? _previousXp;

  XpAnimationNotifier() : super(false);

  void checkAndAnimateXp(int? currentXp) {
    if (_previousXp != null && currentXp != null && currentXp != _previousXp) {
      state = true; // Trigger animation
      Future.delayed(Duration(milliseconds: 500), () {
        state = false; // Reset animation state
      });
    }
    _previousXp = currentXp;
  }
}

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({Key? key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final xpAnimation = ref.watch(xpAnimationProvider);

    // todo - add listeners for predeterminedTasks, userSkillPoints, userAchievements.
    // user-skillpoints and user-achievements will listen to only when THIS USER's user_points and user_ach change, BUT WILL RETURN FULL DATA ON ALL POINTS / ALL ACHIEVEMENTS.
    // implement the model that has -> Achievement + won/not won for the user!!!
    // implement the model that has Skill[ID] -> skill_name, points, perhaps as an INDEXED ARRAY, to make it SCALABLE AND DYNAMIC!

    //Global.predeterminedTasks = ref.watch(predeterminedTaskProvider);
    // final userAchievements = ref.watch(userAchievementsProvider);
    // final userStats = ref.watch(userStatsProvider);

    // Listen to changes in the userProvider and trigger the animation
    ref.listen<UserModel?>(userProvider, (previous, next) {
      if (previous?.xp != next?.xp) {
        ref.read(xpAnimationProvider.notifier).checkAndAnimateXp(next?.xp);
      }
    });

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to the ProfileScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: CircleAvatar(
              backgroundImage:
                  user?.image != null ? NetworkImage(user!.image!) : null,
              backgroundColor: Colors.grey[300],
              child: user?.image == null
                  ? Icon(Icons.person, color: Colors.grey[700])
                  : null,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user?.nickname ?? 'Guest',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: xpAnimation ? 18 : 14,
                  color: xpAnimation ? Colors.green : Colors.grey[500],
                  fontWeight: xpAnimation ? FontWeight.bold : FontWeight.normal,
                ),
                duration: Duration(milliseconds: 200),
                child: Text(
                  'XP: ${user?.xp ?? 0}',
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}