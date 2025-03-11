import "package:fonhakaton2025/data/models.dart";
import "package:fonhakaton2025/data/models/user.dart";

class Global {
  static UserModel? user;

  static void setUser(UserModel? user) {
    Global.user = user;
  }
}
