import 'package:flutter/material.dart';
import 'package:fonhakaton2025/data/models/Group.dart';
import 'package:fonhakaton2025/data/models/user.dart';
import 'package:fonhakaton2025/data/databaseAPI/supabaseAPI.dart';

class GroupDetails extends StatefulWidget {
  final Group group;

  const GroupDetails({super.key, required this.group});

  @override
  _GroupDetailsState createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  late Future<List<UserModel>> _membersFuture;
  late Future<List<UserModel>> _joinRequestsFuture;

  @override
  void initState() {
    super.initState();
    _membersFuture = getGroupMembers(widget.group.groupId);
    _joinRequestsFuture = getUsersGroupJoinRequests(widget.group.groupId);
  }

  void _kickMember(String nickname) async {
    final success = await kickMemberFromGroup(nickname, widget.group.groupId);
    if (success) {
      setState(() {
        _membersFuture =
            getGroupMembers(widget.group.groupId); // Refresh members
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$nickname has been removed from the group')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove member')),
      );
    }
  }

  void _acceptJoinRequest(String nickname) async {
    final success = await acceptJoinRequest(nickname, widget.group.groupId);
    if (success) {
      setState(() {
        _joinRequestsFuture = getUsersGroupJoinRequests(
            widget.group.groupId); // Refresh join requests
        _membersFuture =
            getGroupMembers(widget.group.groupId); // Refresh members
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$nickname has been added to the group')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to accept join request')),
      );
    }
  }

  void _denyJoinRequest(String nickname) async {
    final success = await denyJoinRequest(nickname, widget.group.groupId);
    if (success) {
      setState(() {
        _joinRequestsFuture = getUsersGroupJoinRequests(
            widget.group.groupId); // Refresh join requests
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$nickname\'s join request has been denied')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to deny join request')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        elevation: 0, // Remove shadow for a clean look
        backgroundColor:
            Colors.transparent, // Make the AppBar background transparent
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Name and Description
            Text(
              widget.group.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.group.description ?? "",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),

            // Member Count
            FutureBuilder<List<UserModel>>(
              future: _membersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    "Loading members...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text(
                    "No members found",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  );
                }

                final memberCount = snapshot.data!.length;
                return Text(
                  "Members: $memberCount",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Group Members
            const Text(
              "Members",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<UserModel>>(
                future: _membersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No members found'));
                  }

                  final members = snapshot.data!;
                  return ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: member.image != null
                              ? NetworkImage(member.image!)
                              : const AssetImage('assets/default_avatar.png')
                                  as ImageProvider,
                        ),
                        title: Text(member.nickname),
                        subtitle: Text('XP: ${member.xp}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () {
                            _kickMember(member.nickname); // Kick member
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Join Requests
            const Text(
              "Join Requests",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<UserModel>>(
                future: _joinRequestsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No join requests found'));
                  }

                  final joinRequests = snapshot.data!;
                  return ListView.builder(
                    itemCount: joinRequests.length,
                    itemBuilder: (context, index) {
                      final request = joinRequests[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: request.image != null
                              ? NetworkImage(request.image!)
                              : const AssetImage('assets/default_avatar.png')
                                  as ImageProvider,
                        ),
                        title: Text(request.nickname),
                        subtitle: Text('XP: ${request.xp}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                _acceptJoinRequest(
                                    request.nickname); // Accept join request
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                _denyJoinRequest(
                                    request.nickname); // Deny join request
                              },
                            ),
                          ],
                        ),
                      );
                    },
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
