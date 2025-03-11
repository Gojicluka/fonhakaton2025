import 'package:flutter/material.dart';
import 'package:fonhakaton2025/widgets/Group.dart';

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
  final Group group;
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
          color: group.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(group.icon, color: Colors.white, size: 30),
            Text(
              group.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Icon(group.icon, color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Group group;

  const DetailPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: group.color,
      appBar: AppBar(title: Text(group.name)),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9), // .withValues ...
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(group.icon, size: 80, color: group.color),
              const SizedBox(height: 16),
              Text(
                group.name,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: group.color,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                group.description,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
