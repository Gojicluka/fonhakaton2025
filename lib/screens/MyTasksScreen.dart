import 'package:flutter/material.dart';
import 'package:fonhakaton2025/data/notifiers/UserTaskNotifier.dart';
import 'package:fonhakaton2025/data/models/combined/taskWithState.dart';
import 'package:fonhakaton2025/data/models/task.dart';
import 'package:fonhakaton2025/utils/IconConverter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonhakaton2025/data/PendingTaskNotifier.dart';
import 'package:fonhakaton2025/data/global.dart';
import 'package:fonhakaton2025/data/supabase_helper.dart';
import 'package:fonhakaton2025/data/models/task.dart';
import 'package:fonhakaton2025/data/notifiers/TaskNotifier.dart';
import 'package:fonhakaton2025/utils/IconConverter.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import "package:fonhakaton2025/data/task_completion/task_completion.dart";
import "package:fonhakaton2025/data/PendingTaskNotifier.dart";
import 'package:fonhakaton2025/data/models/combined/taskWithUser.dart';
import 'package:fonhakaton2025/data/databaseAPI/supabaseAPI.dart';

class MyTasks extends StatefulWidget {
  const MyTasks({super.key});

  @override
  _MyTasksState createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Column(
        children: [
          // TabBar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: TabBar(
              labelColor: Colors.black,
              indicatorColor: const Color.fromARGB(255, 0, 0, 0),
              tabs: [
                Tab(icon: Icon(Icons.rate_review), text: "Oceni"),
                Tab(icon: Icon(Icons.check_circle), text: "Rezultat"),
                Tab(icon: Icon(Icons.play_arrow), text: "Aktivno"),
              ],
            ),
          ),
          // TabBarView
          Expanded(
            child: TabBarView(
              children: [
                // Tab 1: Oceni
                NewTaskSegment(
                  title: "Oceni",
                  backgroundColor: Colors.transparent, // No background color
                  onTap: ShowToApproveOther,
                  notifier: evalTaskProvider,
                ),
                // Tab 2: Rezultat
                NewTaskSegment(
                  title: "Rezultat",
                  backgroundColor: Colors.transparent, // No background color
                  onTap: ShowMyPending,
                  notifier: confirmTaskProvider,
                ),
                // Tab 3: Aktivno
                NewTaskSegment(
                  title: "Aktivno",
                  backgroundColor: Colors.transparent, // No background color
                  onTap: ShowMyDoing,
                  notifier: doingTaskProvider,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewTaskSegment extends ConsumerWidget {
  // NewTaskSegment({super.key});

  final String title;
  final Color backgroundColor;
  final void Function(BuildContext, TaskWithState, WidgetRef) onTap;
  final bool isTaskUser; // Determines if we are working with TaskUser
  final dynamic notifier; // todo how to make this safer?

  const NewTaskSegment({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.onTap,
    required this.notifier,
    this.isTaskUser = false, // Default is false (regular Task)
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // used to OBTAIN THE FUTURE ?

    List<TaskWithState> items = [];
    try {
      // do something here
      items = ref.watch(notifier);
      print("ref.watch started for $notifier");
    } catch (e) {
      print('Error in notifier: $e');
    }

    // todo -> add progressIndicator if nothing is happening, somehow...?

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child:Padding( 
              padding: const EdgeInsets.only(left:16),
              child:Text(
                title,
                style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
              return NewTaskWidget(
                task: items[index],
                onTap: () => onTap(context, items[index], ref));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NewTaskWidget extends StatefulWidget {
  final TaskWithState task;
  final VoidCallback onTap;

  const NewTaskWidget({super.key, required this.task, required this.onTap});

  @override
  _NewTaskWidgetState createState() => _NewTaskWidgetState();
}

class _NewTaskWidgetState extends State<NewTaskWidget> {
  String formatDuration(int minutes) {
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;
    return "${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    // Determine the border color based on the task's state
    Color borderColor;
    if (widget.task.isApproved()) {
      borderColor = Colors.green; // Green for accepted tasks
    } else if (widget.task.isDenied()) {
      borderColor = Colors.red; // Red for denied tasks
    } else {
      borderColor = Colors.transparent; // No border for other states
    }

    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(int.parse(widget.task.color.replaceAll('#', '0xff'))), // Convert hex to color
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 3), // Add dynamic border
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(getIconFromString(widget.task.iconName),
                color: Colors.white, size: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.task.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text("XP: ${widget.task.xp}",
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text(formatDuration(widget.task.durationInMinutes),
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 12),
                      const Icon(Icons.people, color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text("${widget.task.pplDoing}/${widget.task.pplNeeded}",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void ShowToApproveOther(BuildContext context, TaskWithState task, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.grey.shade200, // Lighter background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            task.name, // Get the task name
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
              child: Image.network(
                task.imageEvidence ?? "",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person,
                      size: 200, color: Colors.grey);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => denySubmittedTask(context, task),
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
                onPressed: () => acceptSubmittedTask(context, task),
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

void ShowMyDoing(BuildContext context, TaskWithState task, WidgetRef ref) {
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
              task.name,
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
                  task.place,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(width: 20),
                Text(
                  "XP: ${task.xp}",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// what to do? TODOvoid showmypending(BuildContext context, dynamic data) {
void ShowMyPending(BuildContext context, TaskWithState task, WidgetRef ref) {
  Color bubbleColor;
  String statusText;

  if (task.isApproved()) {
    bubbleColor = Colors.green;
    statusText = "Resenje prihvaceno!";
  } else if (task.isDenied()) {
    bubbleColor = Colors.red;
    statusText = "Resenje odbijeno";
  } else {
    bubbleColor = Colors.grey;
    statusText = "Ceka na odobrenje...";
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
          if (task.isApproved()) // Show "Claim Reward" button only if approved
            ElevatedButton(
              onPressed: () => claimReward(context, task, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                "Pokupi xp!",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
              ),
            )
          else
            TextButton(
                onPressed: () {
                if (task.isDenied()) {
                  // Call a different function if the task has been denied
                  print("Task has been denied. Perform specific action here.");
                  confirmTaskDenied(context, task);
                } else {
                  Navigator.pop(context);
                }
                },
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

void CancelTask(BuildContext context, TaskWithState task) {
  // Send a request to the backend to mark the task as canceled
  // the task is removed from the list of tasks, and the task is refreshed.
  // Example: api.cancelTask(task.id);

  deleteUserTask(Global.getUsername(), task.taskId);

  Navigator.pop(context);
}

void CompleteTask(BuildContext context, TaskWithState task) async {
  ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  if (image != null) {
    File _image = File(image.path);

    // uploaduje sliku na bazu, azurira user_task
    // todo : implementirati da azurira pplDoing i pplSubmitted, umesto da se to radi ovde!
    submitUserTask(
        nickname: Global.getUsername(),
        taskId: task.taskId,
        imageEvidence: _image);
  } else {
    print("no image captured");
  }
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

void denySubmittedTask(BuildContext context, TaskWithState task) async {
  // With userDoing and task_id change user_task state to denied, and add the description the people grading the task left.
  // update the number of people who completed the quest! maybe change the ppl count system a bit.
  // todo: implement a text bubble where the user evaluating can add their comment (not required)

  print("button denySubmittedTask pressed");
  String evalDescription = "TODO: Make a bubble to leave a description at!";
  final message = await denyUserTask(
      taskId: task.taskId,
      nickname: task.userDoing,
      evalDescription: evalDescription);
  print(message.message);
  Navigator.pop(context);
}

void acceptSubmittedTask(BuildContext context, TaskWithState task) async {
  // With userDoing and task_id change user_task state to accepted, and add the description the people grading the task left.
  // update the number of people who completed the quest! maybe change the ppl count system a bit.
  // todo: implement a text bubble where the user evaluating can add their comment (not required)

  String evalDescription = "TODO: Make a bubble to leave a description at!";
  await acceptUserTask(
      taskId: task.taskId,
      nickname: task.userDoing,
      evalDescription: evalDescription);
  Navigator.pop(context);
}

void claimReward(BuildContext context, TaskWithState task, WidgetRef ref) async {
  // Example: Update the task state to "rewarded" in the database
  final message = await rewardUserForTask(
    task: task,
    nickname: Global.getUsername(),
  );

  // Show a confirmation message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message.message),
      backgroundColor: Colors.green,
    ),
  );
  // // Refresh the confirmTaskProvider
  // ref.read(confirmTaskProvider.notifier).fetchData();

  Navigator.pop(context); // Close the dialog
}

void confirmTaskDenied(BuildContext context, TaskWithState task) async {
  final message = await userTaskChangeStateToWaitingDelete(
    taskId: task.taskId,
    nickname: Global.getUsername(),
  );
  Navigator.pop(context);
}