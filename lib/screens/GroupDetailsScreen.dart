import 'package:flutter/material.dart';
import 'package:fonhakaton2025/data/models/student_group.dart';
import 'package:fonhakaton2025/widgets/Group.dart';
import 'package:fonhakaton2025/utils/IconConverter.dart';

class ExplorePage extends StatelessWidget {
  ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Groups")),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return GroupTile(
            group: groups[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(group: groups[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class GroupTile extends StatelessWidget {
  final StudentGroup group;
  final VoidCallback onTap;

  const GroupTile({super.key, required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(int.parse(group.color.replaceAll('#', '0xff'))),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(getIconFromString(group.iconName ?? 'Icons.help_outline'),
                color: Colors.white, size: 30),
            Text(
              group.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Icon(getIconFromString(group.iconName ?? 'Icons.help_outline'),
                color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final StudentGroup group;

  const DetailPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse(group.color.replaceAll('#', '0xff'))),
      appBar: AppBar(title: Text(group.name)),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(getIconFromString(group.iconName ?? 'Icons.help_outline'),
                  size: 80,
                  color: Color(int.parse(group.color.replaceAll('#', '0xff')))),
              const SizedBox(height: 16),
              Text(
                group.name,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(int.parse(group.color.replaceAll('#', '0xff'))),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    group.description ?? "",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(int.parse(group.color.replaceAll('#', '0xff'))),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

