import 'package:flutter/material.dart';
import 'package:fonhakaton2025/data/models/task.dart';
import 'package:fonhakaton2025/data/models/task_users.dart';
import 'package:fonhakaton2025/data/models/task_with_user.dart';
import 'package:fonhakaton2025/widgets/icon_converter.dart';

// Hardcoded lists
// final List<TaskWithUser> toApprove = [
//   TaskUser(
//       taskId: 1,
//       userId: 101,
//       photo: "user1.png",
//       description: "Wants to help with logistics."),
//   TaskUser(
//       taskId: 2,
//       userId: 102,
//       photo: "user2.png",
//       description: "Has experience with media tasks."),
// ];

// final List<TaskWithUser> toCompleteGlobalFaculty = [
//   TaskWithUser(
//     id: 3,
//     creatorId: 201,
//     durationMinutes: 90,
//     xpGain: 100,
//     done: false,
//     studentGroupId: null,
//     universityId: 1,
//     location: "Faculty Library",
//     peopleNeeded: 2,
//     isPublic: true,
//     title: "Organize Books",
//     description: "Help sort and organize the library books.",
//     peopleApplied: 1,
//     color: "#FF5733",
//     iconName: "book",
//   ),
// ];

// final List<TaskWithUser> toCompleteGroup = [
//   TaskWithUser(
//     id: 5,
//     creatorId: 203,
//     durationMinutes: 60,
//     xpGain: 80,
//     done: false,
//     studentGroupId: 2,
//     universityId: 1,
//     location: "Media Room",
//     peopleNeeded: 1,
//     isPublic: false,
//     title: "Edit Promotional Video",
//     description: "Edit a short promotional video for the faculty.",
//     peopleApplied: 0,
//     color: "#FFD700",
//     iconName: "video",
//   ),
// ];

// final List<TaskWithUser> toCompleteMyFaculty = [
//   TaskWithUser(
//     id: 7,
//     creatorId: 205,
//     durationMinutes: 30,
//     xpGain: 40,
//     done: false,
//     studentGroupId: null,
//     universityId: 1,
//     location: "Student Lounge",
//     peopleNeeded: 1,
//     isPublic: true,
//     title: "Clean Student Lounge",
//     description: "Help clean and organize the student lounge.",
//     peopleApplied: 1,
//     color: "#32CD32",
//     iconName: "cleaning",
//   ),
// ];

final List<TaskWithUser> toApprove = [
  TaskWithUser(
    taskId: 1,
    creatorId: null,
    durationMinutes: 0,
    xpGain: 0,
    done: false,
    studentGroupId: null,
    universityId: 0,
    location: "",
    peopleNeeded: 0,
    isPublic: false,
    title: "",
    description: "",
    peopleApplied: 0,
    color: "#FFFFFF",
    iconName: "user",
    userId: 101,
    photo: "user1.png",
    userDescription: "Wants to help with logistics.",
  ),
  TaskWithUser(
    taskId: 2,
    creatorId: null,
    durationMinutes: 0,
    xpGain: 0,
    done: false,
    studentGroupId: null,
    universityId: 0,
    location: "",
    peopleNeeded: 0,
    isPublic: false,
    title: "",
    description: "",
    peopleApplied: 0,
    color: "#FFFFFF",
    iconName: "user",
    userId: 102,
    photo: "user2.png",
    userDescription: "Has experience with media tasks.",
  ),
];

final List<TaskWithUser> toCompleteGlobalFaculty = [
  TaskWithUser(
    taskId: 3,
    creatorId: 201,
    durationMinutes: 90,
    xpGain: 100,
    done: false,
    studentGroupId: null,
    universityId: 1,
    location: "Faculty Library",
    peopleNeeded: 2,
    isPublic: true,
    title: "Organize Books",
    description: "Help sort and organize the library books.",
    peopleApplied: 1,
    color: "#FF5733",
    iconName: "book",
    userId: 0,
  ),
];

final List<TaskWithUser> toCompleteGroup = [
  TaskWithUser(
    taskId: 5,
    creatorId: 203,
    durationMinutes: 60,
    xpGain: 80,
    done: false,
    studentGroupId: 2,
    universityId: 1,
    location: "Media Room",
    peopleNeeded: 1,
    isPublic: false,
    title: "Edit Promotional Video",
    description: "Edit a short promotional video for the faculty.",
    peopleApplied: 0,
    color: "#FFD700",
    iconName: "video",
    userId: 0,
  ),
];

final List<TaskWithUser> toCompleteMyFaculty = [
  TaskWithUser(
    taskId: 7,
    creatorId: 205,
    durationMinutes: 30,
    xpGain: 40,
    done: false,
    studentGroupId: null,
    universityId: 1,
    location: "Student Lounge",
    peopleNeeded: 1,
    isPublic: true,
    title: "Clean Student Lounge",
    description: "Help clean and organize the student lounge.",
    peopleApplied: 1,
    color: "#32CD32",
    iconName: "cleaning",
    userId: 0,
  ),
];

class MyTasks extends StatelessWidget {
  const MyTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TaskSegment(
            title: "Moji izdati",
            items: toApprove, // List of TaskUser
            backgroundColor: const Color.fromRGBO(187, 222, 251, 1),
            onTap: ShowToApproveOther,
          ),
          TaskSegment(
            title: "Zavrseni neocenjeni",
            items: toCompleteMyFaculty, // List of Task
            backgroundColor: Colors.green.shade100,
            onTap: ShowMyPending,
          ),
          TaskSegment(
            title: "Trenutni aktivni",
            items: toCompleteGroup, // List of Task
            backgroundColor: Colors.purple.shade100,
            onTap: ShowMyDoing,
          ),
        ],
      ),
    );
  }
}

class TaskSegment extends StatelessWidget {
  final String title;
  final List<TaskWithUser> items; // Can be Task or TaskUser
  final Color backgroundColor;
  final void Function(BuildContext, TaskWithUser) onTap;
  final bool isTaskUser; // Determines if we are working with TaskUser

  const TaskSegment({
    super.key,
    required this.title,
    required this.items,
    required this.backgroundColor,
    required this.onTap,
    this.isTaskUser = false, // Default is false (regular Task)
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return isTaskUser
                    ? TaskUserWidget(
                        user: items[index],
                        onTap: () => onTap(context, items[index]),
                      )
                    : TaskWidget(
                        task: items[index],
                        onTap: () => onTap(context, items[index]),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TaskWidget extends StatelessWidget {
  final TaskWithUser task;
  final VoidCallback onTap;

  const TaskWidget({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Calls the function passed as a parameter
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _parseColor(task.color),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(getIconFromString(task.iconName),
                    color: Colors.white, size: 30),
                const SizedBox(width: 10),
                Text(task.title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
            Text("XP: ${task.xpGain}",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class TaskUserWidget extends StatelessWidget {
  final TaskWithUser user;
  final VoidCallback onTap;

  const TaskUserWidget({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orangeAccent.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/${user.photo ?? "default.png"}'),
              radius: 25,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                user.description ?? "No description",
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void ShowToApproveOther(BuildContext context, TaskWithUser task) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.grey.shade200, // Lighter background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            task.title, // Get the task name
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 200,
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: fetchUserImage("user1.png"), // Placeholder image
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => DenyCompleted(context, task),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Odbij",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              ElevatedButton(
                onPressed: () => AcceptCompleted(context, task),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Prihvati",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void ShowMyDoing(BuildContext context, TaskWithUser task) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.purple, width: 3),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(int.parse(task.color.replaceAll('#', '0xff'))),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              task.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              task.description ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  task.location,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(width: 20),
                Text(
                  "XP: ${task.xpGain}",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text("Nazad",
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: () => CancelTask(context, task),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Odustani", style: TextStyle(fontSize: 18)),
                ),
                ElevatedButton(
                  onPressed: () => CompleteTask(context, task),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Završi", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// what to do? TODOvoid showmypending(BuildContext context, dynamic data) {
void ShowMyPending(BuildContext context, TaskWithUser task) {
  Color bubbleColor;
  String statusText;

  if (task.approved) {
    bubbleColor = Colors.green;
    statusText = "Task completed";
  } else if (task.denied) {
    bubbleColor = Colors.red;
    statusText = "Task failed";
  } else {
    bubbleColor = Colors.grey;
    statusText = "Task not yet reviewed";
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: bubbleColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            statusText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              backgroundColor: Colors.white,
            ),
            child: const Text("OK",
                style: TextStyle(fontSize: 18, color: Colors.black)),
          ),
        ],
      ),
    ),
  );
}

void CancelTask(BuildContext context, TaskWithUser task) {
  // TODO: Send a request to the backend to mark the task as canceled
  // the task is removed from the list of tasks, and the task is refreshed.
  // Example: api.cancelTask(task.id);

  Navigator.pop(context);
}

void CompleteTask(BuildContext context, TaskWithUser task) {
  // TODO camera button
  // opens page that takes you to a camera
  // you can take a picture, and then choose to retake or to send
  // after that the page closes and this popup closes too,
  // and this task gets moved to tasks that are pending.
  // Example: api.completeTask(task.id);

  Navigator.pop(context);
}

Color _parseColor(String colorStr) {
  try {
    return Color(int.parse(colorStr.replaceAll('#', '0xff')));
  } catch (e) {
    return Colors.grey; // Default color if parsing fails
  }
}

Widget fetchUserImage(String imageName) {
  // TODO implement backend logic
  return Image.asset(
    'assets/images/$imageName',
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.person, size: 200, color: Colors.grey);
    },
  );
}

void DenyCompleted(BuildContext context, TaskWithUser task) {
  // TODO: Send a request to the backend to mark the task as denied
  // Example: api.denyTask(task.id);

  Navigator.pop(context);
}

void AcceptCompleted(BuildContext context, TaskWithUser task) {
  // TODO: Send a request to the backend to mark the task as accepted
  // Example: api.acceptTask(task.id);

  Navigator.pop(context);
}
