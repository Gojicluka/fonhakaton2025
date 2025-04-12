import 'package:flutter/material.dart';
import 'package:fonhakaton2025/data/databaseAPI/supabaseAPI.dart';
import 'package:fonhakaton2025/data/models/user.dart';
import 'package:fonhakaton2025/data/global.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late Future<List<UserModel>> _playersFuture;

  @override
  void initState() {
    super.initState();
    _playersFuture = getTopPlayersByXP(Global.user!.uniId ?? 0);
  }

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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _playersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Trenutno nema igraca'));
          }

          final players = snapshot.data!;
          return Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Top 3 Players Podium
                _buildPodium(players),

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
        },
      ),
    );
  }

  // Podium Design for Top 3
  Widget _buildPodium(List<UserModel> players) {
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
      UserModel player, int rank, double height, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: player.image != null
              ? NetworkImage(player.image!)
              : const AssetImage('assets/default_avatar.png') as ImageProvider,
        ),
        const SizedBox(height: 8),
        Text(player.nickname,
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
  Widget _buildPlayerTile(int rank, UserModel player) {
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
            backgroundImage: player.image != null
                ? NetworkImage(player.image!)
                : const AssetImage('assets/default_avatar.png')
                    as ImageProvider,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              player.nickname,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 253, 242, 38)),
            ),
          ),
          Text(
            "${player.xp} xp",
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
