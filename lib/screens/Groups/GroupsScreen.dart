import 'package:flutter/material.dart';
import 'package:fonhakaton2025/data/models/Group.dart';
import 'package:fonhakaton2025/utils/IconConverter.dart';
import 'package:fonhakaton2025/screens/Groups/GroupDetails.dart';
import 'package:fonhakaton2025/data/databaseAPI/supabaseAPI.dart';
import 'package:fonhakaton2025/data/global.dart';

final List<Group> groups = [
  Group(
      groupId: 1,
      name: "Logistika",
      iconName: "water",
      color: "#2196F3",
      description:
          """Radna grupa za logistiku je odgovorna za upravljanje resursima u toku blokada.\nLogistika se bavi: \n-Donacijama: novcanim i konkretnim -u kontaktu je sa ljudima koji doniraju i dogovara se oko vremena dolaska ukoliko je donacija velika\n-Zajednickom kasom: koje je stanje novcanih donacija i evidencija na sta se sve troše pare i koliko (znaci svi prihodi i rashodi)\n-Prostornom organizacijom fakulteta: koja prostorija se koristi u koje svrhe, za koju radnu grupu, gde je menza, sad kad su veliki protesti gde se spava, organizuje ljude koji sprovode u delo donesene prostorne odluke"""
              .trimLeft()),
  Group(
      groupId: 2,
      name: "Dnevni red",
      iconName: "schedule",
      color: "#607D8B",
      description:
          """Dnevni red se bavi poslovima vezanim za optimizaciju rada plenuma, kao i komunikacijom sa upravom fakulteta, profesorima i asistentima.\nOni:\n-Sastavljaju dnevni red: spisak tacaka koje su relevantne za diskusiju i glasanja na plenumu tog dana. \n-Vodjenje plenuma: organizacija moderatora i zapisnicara.\n -Izvestajem nakon svakog plenuma: od zapisnika sa plenuma prave izvestaj.\n-Komunikacijom sa upravom, profesorima i asistentima: izvestavaju ih o odlukama plenuma, i plenum o odlukama uprave"""
              .trimLeft()),
  Group(
      groupId: 3,
      name: "Mediji",
      iconName: "auto_awesome",
      color: "#673AB7",
      description:
          """Radna grupa za medije bavi se pre svega obavestavanjem javnosti o aktuelnim desavanjima vezanim za blokade.\nZaduzenja:\n-Upravljanje nalozima na drustvenim mrezama\n-Priprema studenata za javne nastupe\n-Editovanje snimaka\n-Priprema programa"""
              .trimLeft()),
  Group(
      groupId: 4,
      name: "Komunikacije",
      iconName: "local_fire_department",
      color: "#F44336",
      description:
          """Ova radna grupa odgovorna je za komunikaciju sa drugim fakultetima.\nOd samog pocetka blokada bilo je najbitnije da ostanemo ujedinjeni i medjusobno se konsultujemo o idejama za dalji tok blokada.\nZaduzenja: \n-Ova radna grupa ide na sastanke sa radnim grupama za komunikacije drugih fakulteta\n-Oni prate javno dostupne odluke drugih fakulteta i obavestavaju svoj plenum o njima\n-Ova radna grupa bira delegate koji ce ici na zajednicke skupove"""
              .trimLeft()),
  Group(
      groupId: 5,
      name: "Agitacija i motivacija",
      iconName: "local_florist",
      color: "#E91E63",
      description:
          """Radna grupa za agitaciju i motivaciju ima ključnu ulogu u mobilizaciji ljudi i povećavanju angazovanja učesnika.\nNjihov cilj je da  inspirišu i ohrabre ljude da se pridruže protestima. \nOni rade naodržavanju energije i odlučnosti među učesnicima tokom protesta.\n\nZaduzenja radne grupe:\n-Pravljenje transparenata\n-Komunikacija sa licnostima koje odrzavaju radionice/predavanja/.. \n-Organizacija zajednickih aktivnosti"""
              .trimLeft()),
  Group(
      groupId: 6,
      name: "Bezbednost",
      iconName: "shield",
      color: "#795548",
      description:
          """Radna grupa za bezbednost kljucna je u organizaciji svih akcija i blokada.\nZaduzenja bezbednosti:\n-Redarenje na blokadama\n-Sastavljanje bezbednosnog plana pred svaku akciju\n-Organizacija cuvara zgrade fakulteta\n-Odrzavanje reda i mira na fakultetu"""
              .trimLeft()),
];

class GroupsScreen extends StatelessWidget {
  GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: Column(
          children: [
            // Tab Bar at the Top
            Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: const TabBar(
                labelColor: Color.fromARGB(255, 0, 0, 0),
                indicatorColor: Color.fromARGB(255, 0, 0, 0),
                tabs: [
                  Tab(icon: Icon(Icons.group_add), text: 'Join'), // "Join" tab
                  Tab(
                      icon: Icon(Icons.groups),
                      text: 'My Groups'), // "My Groups" tab
                ],
              ),
            ),
            // Tab Views
            Expanded(
              child: TabBarView(
                children: [
                  // First Tab: Join Groups
                  FutureBuilder<List<Group>>(
                    future: getAllGroupsExceptUserGroups(Global.getUsername()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text("No groups available to join."));
                      } else {
                        return GroupListView(
                          groups: snapshot.data!,
                          onTap: (group) {
                            _showJoinGroupDialog(context, group);
                          },
                        );
                      }
                    },
                  ),
                  // Second Tab: My Groups
                  FutureBuilder<List<Group>>(
                    future: getAllUserGroups(Global.getUsername()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text("You are not part of any groups."));
                      } else {
                        return MyGroupsView(
                          groups: snapshot.data!,
                          onTap: (group) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GroupDetails(group: group),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinGroupDialog(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            group.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.description ?? "No description available.",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      getIconFromString(group.iconName ?? 'Icons.help_outline'),
                      size: 40,
                      color:
                          Color(int.parse(group.color.replaceAll('#', '0xff'))),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Color: ${group.color}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final success =
                    await joinGroup(Global.getUsername(), group.groupId);
                if (success) {
                  Navigator.pop(context); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("You have joined ${group.name}!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to join the group.")),
                  );
                }
              },
              child: const Text("Join"),
            ),
          ],
        );
      },
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
  final Group group;

  const DetailPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse(group.color.replaceAll('#', '0xff'))),
      body: Column(
        children: [
          // Group Details
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      getIconFromString(group.iconName ?? 'Icons.help_outline'),
                      size: 80,
                      color:
                          Color(int.parse(group.color.replaceAll('#', '0xff'))),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      group.name,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(
                            int.parse(group.color.replaceAll('#', '0xff'))),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          group.description ?? "",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(
                                int.parse(group.color.replaceAll('#', '0xff'))),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupListView extends StatelessWidget {
  final List<Group> groups;
  final void Function(Group) onTap;

  const GroupListView({super.key, required this.groups, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return GroupTile(
          group: groups[index],
          onTap: () => onTap(groups[index]),
        );
      },
    );
  }
}

class MyGroupsView extends StatelessWidget {
  final List<Group> groups; // Replace with the user's groups
  final void Function(Group) onTap;

  const MyGroupsView({super.key, required this.groups, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return GroupTile(
          group: groups[index],
          onTap: () => onTap(groups[index]),
        );
      },
    );
  }
}
