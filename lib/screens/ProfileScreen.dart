import 'package:flutter/material.dart';
import 'package:fonhakaton2025/data/global.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart package
import '../achievement.dart';
import 'package:fonhakaton2025/data/models/task.dart';

List<Task> tasks = [
  Task(
    taskId: 1,
    name: "Clean the Library",
    description: "Help clean and organize the library.",
    place: "University Library",
    uniId: 101,
    xp: 50,
    groupId: 1,
    urgent: false,
    existsForTime: 48,
    pplNeeded: 5,
    pplDoing: 3,
    pplSubmitted: 2,
    createdBy: "Admin",
    color: "#FF5733",
    iconName: "cleaning_services",
    timeForPlayer: 120,
  ),
  Task(
    taskId: 2,
    name: "Campus Gardening",
    description: "Assist in planting flowers around the campus.",
    place: "Campus Garden",
    uniId: 102,
    xp: 70,
    groupId: 2,
    urgent: true,
    existsForTime: 24,
    pplNeeded: 10,
    pplDoing: 7,
    pplSubmitted: 5,
    createdBy: "Admin",
    color: "#4CAF50",
    iconName: "park",
    timeForPlayer: 180,
  ),
  Task(
    taskId: 3,
    name: "Event Setup",
    description: "Help set up the stage and seating for the annual event.",
    place: "Main Auditorium",
    uniId: 103,
    xp: 100,
    groupId: 3,
    urgent: true,
    existsForTime: 12,
    pplNeeded: 8,
    pplDoing: 6,
    pplSubmitted: 4,
    createdBy: "EventManager",
    color: "#2196F3",
    iconName: "event",
    timeForPlayer: 240,
  ),
];

class ProfileScreen extends StatelessWidget {
  //generic to be changed later

  void handleLogout() {
    // Currently, it does nothing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moj nalog'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.purple),
            onPressed: handleLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... (profile picture, name, XP progress, buttons) ...
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: Global.user?.image != null
                      ? NetworkImage(Global.user!.image!)
                      : null,
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  Global.user!.nickname,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              Text('XP tokom nedelje:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    gridData: FlGridData(show: false), // Disable grid lines
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) =>
                              const Text(''), // Empty string
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) =>
                              const Text(''), // Empty string
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) =>
                              const Text(''), // Empty string
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final days = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun'
                            ];
                            return Text(days[value.toInt()]);
                          },
                        ),
                      ),
                    ),

                    borderData: FlBorderData(
                      show: false, // Remove all borders
                    ),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [
                        BarChartRodData(
                            toY: 120,
                            color: Colors.purple[300],
                            width: 20,
                            borderRadius: BorderRadius.circular(6))
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(
                            toY: 250,
                            color: Colors.purple[400],
                            width: 20,
                            borderRadius: BorderRadius.circular(6))
                      ]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(
                            toY: 180,
                            color: Colors.purple[500],
                            width: 20,
                            borderRadius: BorderRadius.circular(6))
                      ]),
                      BarChartGroupData(x: 3, barRods: [
                        BarChartRodData(
                            toY: 300,
                            color: Colors.purple[600],
                            width: 20,
                            borderRadius: BorderRadius.circular(6))
                      ]),
                      BarChartGroupData(x: 4, barRods: [
                        BarChartRodData(
                            toY: 280,
                            color: Colors.purple[700],
                            width: 20,
                            borderRadius: BorderRadius.circular(6))
                      ]),
                      BarChartGroupData(x: 5, barRods: [
                        BarChartRodData(
                            toY: 150,
                            color: Colors.purple[800],
                            width: 20,
                            borderRadius: BorderRadius.circular(6))
                      ]),
                      BarChartGroupData(x: 6, barRods: [
                        BarChartRodData(
                            toY: 200,
                            color: Colors.purple[900],
                            width: 20,
                            borderRadius: BorderRadius.circular(6))
                      ]),
                    ],
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
                            title: Text('Bedzevi'),
                            content: Container(
                              width: double.maxFinite,
                              child: ProfileAchievements(),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Nazad'),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text('Dostignuća'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Završeni kvestovi'),
                            content: Container(
                              width: double.maxFinite,
                              child: ProfileTasks(),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Nazad'),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text('Kvest'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Bedzevi:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              AchievementIcons(), // Use AchievementIcons here
            ],
          ),
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
                  "imee",
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
                      "Nivo: 3",
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
    final List<int> xpData =
        List.generate(7, (index) => (50 + index * 30 + (index % 3) * 20));

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false), // Hide grid lines
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false), // Hide left numbers
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return Text(days[value.toInt()],
                    style: TextStyle(fontSize: 12));
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: xpData.reduce((a, b) => a > b ? a : b).toDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: xpData.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.toDouble());
            }).toList(),
            isCurved: true,
            color: Color(0xFF9C27B0),
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Color(0xFF9C27B0).withOpacity(0.3),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.black87,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toInt()} XP',
                  TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),
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

  Widget _buildAchievementCard(BuildContext context, String title,
      String description, IconData icon, Color color, DateTime date) {
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
              subtitle: Padding(
                // Added subtitle for description
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
          return _buildTaskCard(context, task, DateTime.now());
        }).toList(),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task, DateTime date) {
    return Card(
      color: Colors.accents[tasks.indexOf(task) % Colors.accents.length],
      margin: const EdgeInsets.all(10),
      child: Stack(
        // Use Stack to overlay the date
        children: [
          ListTile(
            leading: const Icon(Icons.check, color: Colors.white),
            title:
                Text(task.name, style: GoogleFonts.lato(color: Colors.white)),
          ),
          Positioned(
            // Position the date at the top right
            top: 8,
            right: 8,
            child: Text(
              DateFormat('MMM dd, yyyy').format(date), // Format the date
              style: GoogleFonts.lato(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ... (allAchievements and tasks lists remain the same)
List<Achievement> allAchievements = [
  Achievement(
    name: "Zlatni Moderator",
    description:
        "Dostignuće za 5 uspešnih moderiranja. Hvala vam na posvećenosti!",
    icon: Icons.military_tech,
    color: const Color.fromARGB(255, 110, 8, 86),
  ),
  Achievement(
    name: "Srebrni Moderator",
    description:
        "Dostignuće za 3 uspešna moderiranja. Nastavite sa dobrim radom!",
    icon: Icons.military_tech_outlined,
    color: const Color.fromARGB(255, 48, 164, 104),
  ),
  Achievement(
    name: "Moderator",
    description:
        "Dostignuće za jedno uspešno moderiranje. Hvala vam što ste deo tima!",
    icon: Icons.people,
    color: const Color.fromARGB(255, 2, 40, 71),
  ),
  Achievement(
    name: "Zapisničar",
    description:
        "Dostignuće za uspešno vođenje zapisnika. Vaš doprinos je dragocen!",
    icon: Icons.computer,
    color: Colors.green,
  ),
  Achievement(
    name: "Zlatni Čuvar Fakulteta",
    description:
        "Dostignuće za 5 uspešnih čuvanja ulaza fakulteta. Hvala vam na posvećenosti i brizi!",
    icon: Icons.security,
    color: const Color.fromARGB(255, 196, 101, 166),
  ),
  Achievement(
    name: "Srebrni Čuvar Fakulteta",
    description:
        "Dostignuće za 3 uspešna čuvanja ulaza fakulteta. Vaš rad je od velike pomoći!",
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
    description:
        "Dostignuće za učešće u redarskoj službi na blokadama. Hvala vam na angažmanu!",
    icon: Icons.accessibility_new,
    color: const Color.fromARGB(255, 175, 110, 14),
  ),
];
