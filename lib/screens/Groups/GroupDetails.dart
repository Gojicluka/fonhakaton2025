import 'package:flutter/material.dart';
import 'package:fonhakaton2025/data/models/Group.dart';

class GroupDetails extends StatelessWidget {
  final Group group;

  const GroupDetails({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    // Mock data for members and join requests
    final List<String> members = [
      "Alice",
      "Bob",
      "Charlie",
      "Diana",
      "Eve",
    ];

    final List<String> joinRequests = [
      "Frank",
      "Grace",
      "Hank",
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        elevation: 0, // Remove shadow for a clean look
        backgroundColor: Colors.transparent, // Make the AppBar background transparent
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Name and Member Count
            Text(
              group.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Members: ${members.length}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // Scrollable List of Members
            const Text(
              "Members",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(members[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        // Mock API call to kick the member
                        print("Kicked ${members[index]}");
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Scrollable List of Join Requests
            const Text(
              "Join Requests",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: joinRequests.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.person_add),
                    title: Text(joinRequests[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            // Mock API call to accept the join request
                            print("Accepted ${joinRequests[index]}");
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            // Mock API call to deny the join request
                            print("Denied ${joinRequests[index]}");
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



