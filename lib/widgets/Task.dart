// Generates a static task ID (will be dynamic later)
int generateTaskId() {
  return 1001; // Placeholder, replace with backend logic later
}

class Task {
  final int id;
  final String title;
  final int xp;
  final int durationMinutes;
  final String groupName;
  final String location;
  final String faculty; // Added faculty
  int appliedPeople; // Mutable
  final int neededPeople;
  bool isPublic;
  final String description;
  final String createdBy; // Nickname of the creator
  //DateTime date;

  Task(
      this.title,
      this.xp,
      this.durationMinutes,
      this.groupName,
      this.location,
      this.faculty, // Added in constructor
      this.appliedPeople,
      this.neededPeople,
      this.isPublic,
      this.description,
      this.createdBy,
      /*this.date*/)
      : id = generateTaskId();
}

// Updated task list with "ETF" as the faculty
final List<Task> tasks = [
  Task("Baci smeće", 20, 15, "Logistika", "Kontejner ispred zgrade", "ETF", 1,
      0, true, "Iznesi smeće do kontejnera ispred zgrade.", "Milica",/*DateTime.now()*/),
  Task("Operi sudove", 30, 30, "Dnevni red", "Kuhinja", "ETF", 1, 1, true,
      "Očisti i operi sudove nakon doručka.", "Luka",/*DateTime.now()*/),
  Task("Čuvaj vrata", 50, 120, "Red", "Glavni ulaz", "ETF", 2, 1, true,
      "Obezbeđuj glavni ulaz tokom događaja.", "Irena",/*DateTime.now()*/),
  Task("Odnesi dušeke u 115", 40, 90, "Logistika", "Soba 115", "ETF", 2, 0,
      false, "Prenesi rezervne dušeke u sobu 115.", "Vladana",/*DateTime.now()*/),
  Task("Dočekuj donacije", 60, 180, "Mediji", "Skladište", "ETF", 3, 2, true,
      "Pomozi u prijemu i sortiranju donacija.", "Milica",/*DateTime.now()*/),
  Task("Sortiraj opremu", 35, 60, "Logistika", "Magacin", "ETF", 2, 1, true,
      "Razvrstaj i složi opremu u magacinu.", "Luka",/*DateTime.now()*/),
];