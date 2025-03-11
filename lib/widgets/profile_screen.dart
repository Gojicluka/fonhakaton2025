import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart package
import 'Task.dart';
import '../achievement.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (profile picture, name, XP progress, buttons) ...
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('../../assets/nanana.png'),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'myusername',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Text('XP Progress:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: BarChart(
                // ... (BarChart code) ...
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return Text(days[value.toInt()]);
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  barGroups: List.generate(7, (index) =>
                      BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(toY: (index + 1) * 10.0, color: Colors.blue, width: 16),
                        ],
                      ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('My Achievements'),
                          content: Container(
                            width: double.maxFinite,
                            child: ProfileAchievements(),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text('Achievements'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Done Tasks'),
                          content: Container(
                            width: double.maxFinite,
                            child: ProfileTasks(),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text('Tasks'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Achievements:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AchievementIcons(), // Use AchievementIcons here
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('../../assets/image.png'),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Player Name",
                  style: GoogleFonts.lato(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 2, 1, 14),
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Level: 3",
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 16, 1, 16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "XP: 1200/1500",
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: const Color(0xFFDDA0DD),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class XPChart extends StatelessWidget {
  const XPChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate random XP data for the past week
    final List<int> xpData = List.generate(7, (index) => (50 + index * 30 + (index % 3) * 20));

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: xpData.reduce((value, element) => value > element ? value : element).toDouble(),
        lineBarsData: [
          LineChartBarData(
              spots: xpData.asMap().entries.map((entry) {
               return FlSpot(entry.key.toDouble(), entry.value.toDouble());
              }).toList(),
              isCurved: true,
              color: const Color(0xFF9C27B0), // Use a list of Color objects
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF9C27B0).withOpacity(0.3), // Corrected property name
              ),
          ),
        ],
      ),
    );
  }
}

class AchievementIcons extends StatelessWidget {
  const AchievementIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Horizontal scrolling
      child: Row(
        children: allAchievements.map((achievement) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              backgroundColor: achievement.color,
              child: Icon(achievement.icon, color: Colors.white),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ProfileAchievements extends StatelessWidget {
  const ProfileAchievements({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: allAchievements.map((achievement) {
          return _buildAchievementCard(
            context,
            achievement.name,
            achievement.description,
            achievement.icon,
            achievement.color,
            achievement.dateAchieved ?? DateTime.now(),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAchievementCard(
      BuildContext context,
      String title,
      String description,
      IconData icon,
      Color color,
      DateTime date) {
    return Card(
      color: color,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Stack(
          children: [
            ListTile(
              leading: Icon(icon, color: Colors.white, size: 36),
              title: Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding( // Added subtitle for description
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  description,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Text(
                DateFormat('yyyy-MM-dd').format(date),
                style: GoogleFonts.lato(fontSize: 12, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTasks extends StatelessWidget {
  const ProfileTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: tasks.map((task) {
          return _buildTaskCard(
            context,
            task,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    return Card(
      color: Colors.accents[tasks.indexOf(task) % Colors.accents.length],
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: const Icon(Icons.check, color: Colors.white),
        title: Text(task.title, style: GoogleFonts.lato(color: Colors.white)),
      ),
    );
  }
}

// ... (allAchievements and tasks lists remain the same)
List<Achievement> allAchievements = [
  Achievement(
    name: "Zlatni Moderator",
    description: "Dostignuće za 5 uspešnih moderiranja. Hvala vam na posvećenosti!",
    icon: Icons.military_tech,
    color: const Color.fromARGB(255, 110, 8, 86),
  ),
  Achievement(
    name: "Srebrni Moderator",
    description: "Dostignuće za 3 uspešna moderiranja. Nastavite sa dobrim radom!",
    icon: Icons.military_tech_outlined,
    color: const Color.fromARGB(255, 48, 164, 104),
  ),
  Achievement(
    name: "Moderator",
    description: "Dostignuće za jedno uspešno moderiranje. Hvala vam što ste deo tima!",
    icon: Icons.people,
    color: const Color.fromARGB(255, 2, 40, 71),
  ),
  Achievement(
    name: "Zapisničar",
    description: "Dostignuće za uspešno vođenje zapisnika. Vaš doprinos je dragocen!",
    icon: Icons.computer,
    color: Colors.green,
  ),
  Achievement(
    name: "Zlatni Čuvar Fakulteta",
    description: "Dostignuće za 5 uspešnih čuvanja ulaza fakulteta. Hvala vam na posvećenosti i brizi!",
    icon: Icons.security,
    color: const Color.fromARGB(255, 196, 101, 166),
  ),
  Achievement(
    name: "Srebrni Čuvar Fakulteta",
    description: "Dostignuće za 3 uspešna čuvanja ulaza fakulteta. Vaš rad je od velike pomoći!",
    icon: Icons.security_outlined,
    color: const Color.fromARGB(255, 85, 24, 24),
  ),
  Achievement(
    name: "Čuvar Fakulteta",
    description: "Dostignuće za čuvanje fakulteta. Hvala Vam na pomoći!",
    icon: Icons.security,
    color: Colors.blue,
  ),
  Achievement(
    name: "Redar",
    description: "Dostignuće za učešće u redarskoj službi na blokadama. Hvala vam na angažmanu!",
    icon: Icons.accessibility_new,
    color: const Color.fromARGB(255, 175, 110, 14),
  ),
];