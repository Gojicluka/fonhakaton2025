// import 'package:flutter/material.dart';
// import 'package:fonhakaton2025/widgets/icon_converter.dart';
// import 'package:fonhakaton2025/data/models/task.dart';
// import 'package:fonhakaton2025/data/models/student_group.dart';

// class MyTasksPage extends StatelessWidget {
//   const MyTasksPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Tasks"),
//         backgroundColor: Colors.amber,
//       ),
//       body: ListView(
//         children: [
//           _buildCategory(
//               "Approve Quests", _approveQuests, Colors.orange.shade300),
//           _buildCategory(
//               "Pending Quests", _pendingQuests, Colors.blue.shade300),
//           _buildCategory("Current Quests - Global", _currentQuestsGlobal,
//               Colors.green.shade300),
//           _buildCategory("Current Quests - My University",
//               _currentQuestsUniversity, Colors.purple.shade300),
//           ..._groups
//               .map((group) =>
//                   _buildCategory(group.name, group.tasks, Colors.teal.shade300))
//               .toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategory(String title, List<Task> tasks, Color backgroundColor) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 10),
//           ...tasks
//               .map((task) => TaskWidget(task: task))
//               .toList(), // overrideColor: task.overrideColor
//         ],
//       ),
//     );
//   }
// }

// class TaskWidget extends StatelessWidget {
//   final Task task;
//   final Color? overrideColor;

//   const TaskWidget({super.key, required this.task, this.overrideColor});

//   @override
//   Widget build(BuildContext context) {
//     Color taskColor =
//         overrideColor ?? Color(int.parse(task.color.replaceAll('#', '0xff')));

//     return GestureDetector(
//       onTap: () => _showTaskDialog(context, task, taskColor),
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: taskColor,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Icon(getIconFromString(task.iconName),
//                 color: Colors.white, size: 30),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     task.title,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.star, color: Colors.white, size: 18),
//                       const SizedBox(width: 4),
//                       Text("XP: ${task.xpGain}",
//                           style: const TextStyle(color: Colors.white)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showTaskDialog(BuildContext context, Task task, Color taskColor) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//           side: const BorderSide(color: Colors.amber, width: 3),
//         ),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: taskColor,
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 task.title,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 task.description ?? "",
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 18, color: Colors.white),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: TextButton.styleFrom(backgroundColor: Colors.white),
//                     child: const Text("Close",
//                         style: TextStyle(fontSize: 18, color: Colors.black)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// final List<Task> _approveQuests = [
//   Task(
//       id: 1,
//       durationMinutes: 60,
//       xpGain: 100,
//       universityId: 1,
//       location: "Library",
//       peopleNeeded: 3,
//       title: "Approve Research Paper",
//       description: "Review and approve a research submission.",
//       peopleApplied: 1,
//       color: "#FF5722"),
// ];

// final List<Task> _pendingQuests = [
//   Task(
//       id: 2,
//       durationMinutes: 30,
//       xpGain: 50,
//       universityId: 1,
//       location: "Lab",
//       peopleNeeded: 2,
//       title: "Pending Experiment Approval",
//       description: "Wait for professor approval.",
//       peopleApplied: 1,
//       color: "#2196F3"),
// ];

// final List<Task> _currentQuestsGlobal = [
//   Task(
//       id: 3,
//       durationMinutes: 45,
//       xpGain: 75,
//       universityId: 2,
//       location: "Online",
//       peopleNeeded: 4,
//       title: "Global Coding Challenge",
//       description: "Compete in an online hackathon.",
//       peopleApplied: 2,
//       color: "#4CAF50"),
// ];

// final List<Task> _currentQuestsUniversity = [
//   Task(
//       id: 4,
//       durationMinutes: 60,
//       xpGain: 90,
//       universityId: 1,
//       location: "Auditorium",
//       peopleNeeded: 5,
//       title: "University Debate",
//       description: "Participate in an inter-university debate.",
//       peopleApplied: 3,
//       color: "#9C27B0"),
// ];

// final List<StudentGroup> _groups = [
//   StudentGroup(
//       id: 1,
//       name: "Logistika",
//       iconName: "shield",
//       color: "#795548",
//       description: "Manage logistics tasks.",
//       tasks: [
//         Task(
//             id: 5,
//             durationMinutes: 90,
//             xpGain: 120,
//             universityId: 1,
//             location: "Warehouse",
//             peopleNeeded: 2,
//             title: "Inventory Check",
//             description: "Verify stock levels.",
//             peopleApplied: 1,
//             color: "#795548"),
//       ]),
// ];
