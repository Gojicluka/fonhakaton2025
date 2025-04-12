import "package:fonhakaton2025/data/databaseAPI/supabaseAPI.dart";
import "package:fonhakaton2025/data/models/user.dart";

enum GroupCode { JAVNO }

class Global {
  static UserModel? user;
  static List<Map<String, dynamic>>? predeterminedTasks;
  static List<Map<String, dynamic>>? userGroups;

  static void setUser(UserModel? user) {
    Global.user = user;
  }

  //   static void setUser(String username) async {
  //   Global.user = await getUserByName(username);
  //   print("Got user: ${Global.user}");
  // }

  static void setPredeterminedTasks(
      List<Map<String, dynamic>>? predeterminedTasks) {
    Global.predeterminedTasks = predeterminedTasks;
  }

  static List<Map<String, dynamic>>? getPredeterminedTasks() {
    return predeterminedTasks;
  }

  static Future<void> setUserGroups(String username) async {
    userGroups = await getUserGroupsWithNames(username);
    print("user groups: $userGroups");
    print(predeterminedTasks!.where((task) => (task['for_group']) as int == 0));
    print(predeterminedTasks!.where((task) => (task['for_group']) as int == 1));
    print(predeterminedTasks!.where((task) => task['for_group'] as int == 2));
  }

  static String getUsername() {
    if (Global.user != null) {
      return Global.user!.nickname;
    } else {
      return "none";
    }
  }

  static List<Map<String, dynamic>>? getUserGroups() {
    print("getUserGroups: ${Global.userGroups}");
    return userGroups;
  }

  // static List<Map<String, dynamic>>? getPredeterminedTasksWhereGroup(int group_id){
  //   return List.from(userGroups!,)
  // }
}
