import 'package:flutter/material.dart';

class Player {
  final String name;
  final String imageUrl;
  final int points;

  Player({required this.name, required this.imageUrl, required this.points});
}

class LeaderboardPage extends StatelessWidget {
  final List<Player> players = [
    Player(name: "cana", imageUrl: "https://picsum.photos/250", points: 1500),
    Player(name: "kekss", imageUrl: "https://picsum.photos/251", points: 1400),
    Player(name: "irkee", imageUrl: "https://picsum.photos/252", points: 1300),
    Player(
        name: "miksa99", imageUrl: "https://picsum.photos/253", points: 1100),
    Player(name: "paki", imageUrl: "https://picsum.photos/254", points: 1000),
    Player(name: "marko3", imageUrl: "https://picsum.photos/255", points: 900),
    Player(name: "cira", imageUrl: "https://picsum.photos/256", points: 800),
  ];

  LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "🏆 Tri koja blokiraju",
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0)),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255,
            255), // const Color.fromARGB(255, 78, 125, 234), // todo change
        elevation: 0,
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255), // Light wood brown color
        child: Column(
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
      ),
    );
  }

  // Podium Design for Top 3
  Widget _buildPodium() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPodiumPlayer(
            players[1], 2, 80, Colors.grey[400]!), // 2nd place (Silver)
        _buildPodiumPlayer(
            players[0], 1, 100, Colors.yellow[700]!), // 1st place (Gold)
        _buildPodiumPlayer(
            players[2], 3, 60, Colors.brown[400]!), // 3rd place (Bronze)
      ],
    );
  }

  Widget _buildPodiumPlayer(
      Player player, int rank, double height, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(player.imageUrl),
        ),
        const SizedBox(height: 8),
        Text(player.name,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0))),
        Container(
          width: 70,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: rank == 1
              ? const Icon(Icons.military_tech,
                  color: Colors.yellow, size: 30) // Gold Medal
              : rank == 2
                  ? const Icon(Icons.military_tech,
                      color: Colors.grey, size: 30) // Silver Medal
                  : const Icon(Icons.military_tech,
                      color: Colors.brown, size: 30), // Bronze Medal
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
        color: Colors.brown,
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
          // For players ranked 4th and below, just display the rank as a number
          Text(
            "#$rank",
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 253, 242, 38)),
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
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 253, 242, 38)),
            ),
          ),
          Text(
            "${player.points} xp",
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 253, 242, 38)),
          ),
        ],
      ),
    );
  }
}
