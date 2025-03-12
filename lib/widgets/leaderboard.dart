import 'package:flutter/material.dart';

class Player {
  final String name;
  final String imageUrl;
  final int points;

  Player({required this.name, required this.imageUrl, required this.points});
}

class LeaderboardPage extends StatelessWidget {
  final List<Player> players = [
    Player(name: "Alice", imageUrl: "https://i.pravatar.cc/150?img=1", points: 1500),
    Player(name: "Bob", imageUrl: "https://i.pravatar.cc/150?img=2", points: 1400),
    Player(name: "Charlie", imageUrl: "https://i.pravatar.cc/150?img=3", points: 1300),
    Player(name: "David", imageUrl: "https://i.pravatar.cc/150?img=4", points: 1100),
    Player(name: "Emma", imageUrl: "https://i.pravatar.cc/150?img=5", points: 1000),
    Player(name: "Frank", imageUrl: "https://i.pravatar.cc/150?img=6", points: 900),
    Player(name: "Grace", imageUrl: "https://i.pravatar.cc/150?img=7", points: 800),
  ];

  LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🏆 Leaderboard"),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Top 3 Players Podium
          _buildPodium(),

          const SizedBox(height: 20),

          // Remaining Players List
          Expanded(
            child: ListView.builder(
              itemCount: players.length - 3,
              itemBuilder: (context, index) {
                final player = players[index + 3];
                return _buildPlayerTile(index + 4, player);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Podium Design for Top 3
  Widget _buildPodium() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPodiumPlayer(players[1], 2, 80, Colors.grey[400]!), // 2nd place (Silver)
        _buildPodiumPlayer(players[0], 1, 100, Colors.yellow[700]!), // 1st place (Gold)
        _buildPodiumPlayer(players[2], 3, 60, Colors.brown[400]!), // 3rd place (Bronze)
      ],
    );
  }

  Widget _buildPodiumPlayer(Player player, int rank, double height, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(player.imageUrl),
        ),
        const SizedBox(height: 8),
        Text(player.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Container(
          width: 70,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "#$rank",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // Regular List Item for Players Ranked 4th and Below
  Widget _buildPlayerTile(int rank, Player player) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            "#$rank",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(player.imageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              player.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            "${player.points} pts",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
        ],
      ),
    );
  }
}
