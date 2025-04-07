import "package:fonhakaton2025/data/models/user.dart";

class Global {
  static UserModel? user;

  static void setUser(UserModel? user) {
    Global.user = user;
  }

  static String getUsername() {
    if (Global.user != null) {
      return Global.user!.nickname;
    } else {
      return "none";
    }
  }
}
