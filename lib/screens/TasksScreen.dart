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
import 'package:fonhakaton2025/data/databaseAPI/supabaseAPI.dart';

void sendReport(BuildContext context, Task task) async {
  // ImagePicker _picker = ImagePicker();
  // final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  // if (image != null) {
  //   File _image = File(image.path);

  //   submitTaskCompletion(
  //       taskId: task.id, userId: Global.user!.id, imageFile: _image);
  // } else {
  //   print("no image captured");
  // }
  // Navigator.pop(context);
}

void _acceptTask(BuildContext context, Task task) async {
  final message = await createUserTask(Global.getUsername(), task.taskId);
  // listener se ne azurira lepo zapravo, trebalo bi da se refrehsuje i kad se promeni user_task i kad se promeni tasks
  // todo !!

  print("message: ${message.message}");
  Navigator.pop(context);
  // setState(() {});

  // Adds the selected task to a list of active tasks
  //activeTasks.add(task);

  // Increases the amount of people who have accepted the quest
  // and the player can't accept it again. Perhaps show that the quest has been accepted somewhere.
  //task.appliedPeople += 1;

  // Pop the context to close the dialog
  //   SupabaseHelper.addUserToTask(taskId: task.id, userId: Global.user!.id);
  //   print("SEFINO");
  //   SupabaseHelper.updateTaskPeopleApplied(
  //       taskId: task.id, peopleApplied: task.peopleApplied + 1);
  //   Navigator.pop(context);
  // }
}

void approveTask(BuildContext context, Task task) async {
  // await approveTaskCompletion(taskId: task.taskId, userId: task.userId);
  // Navigator.pop(context);
}

void denyTask(BuildContext context, Task task) async {
  // await denyTaskCompletion(taskId: task.taskId, userId: task.userId);
  // Navigator.pop(context);
}

class PublicTaskPage extends StatelessWidget {
  PublicTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: Column(
          children: [
            const TabBar(
              labelColor: Colors.black,
              indicatorColor: Color.fromARGB(255, 0, 0, 0),
              tabs: [
                Tab(icon: Icon(Icons.public), text: 'Svi zadaci'),
                Tab(icon: Icon(Icons.work), text: 'Zadaci radne grupe'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // First Tab Content
                  TaskListView(
                    taskProvider:
                        taskProvider, // Replace with the appropriate provider
                    title: 'Svi zadaci',
                  ),
                  // Second Tab Content
                  TaskListView(
                    taskProvider:
                        groupTaskProvider, // Replace with the appropriate provider
                    title: 'Zadaci radne grupe',
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

class TaskListView extends ConsumerWidget {
  final StateNotifierProvider taskProvider;
  final String title;

  const TaskListView(
      {super.key, required this.taskProvider, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft, // Aligns the title to the left
            child: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index] as Task;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TaskScreen(task: task, isReported: false),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TaskScreen extends StatefulWidget {
  final Task task;
  bool isReported = false;

  TaskScreen({super.key, required this.task, this.isReported = false}) {}

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String formatDuration(int minutes) {
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;
    return "${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}";
  }

  // @override
  // void setState(VoidCallback fn) {
  //   // TODO: implement setState
  //   super.setState(fn);
  // }

  void showTaskDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.amber, width: 3),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(int.parse(task.color
                .replaceAll('#', '0xff'))), // Background color = Group color
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
              if (task.place.length > 15) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.place,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "XP: ${task.xp}",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white, size: 24),
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
              ],
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Zatvori",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  if (!widget.isReported)
                    ElevatedButton(
                      onPressed: () => {
                        _acceptTask(context, task),
                        setState(() {
                          widget.isReported = true;
                        })
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        "Prihvati zadatak",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  if (widget.isReported)
                    ElevatedButton(
                      onPressed: () => setState(() {
                        widget.isReported = false;
                      }),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Odjavi zadatak",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                ],
              ),
              if (widget.isReported)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      sendReport(context, task);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Send Report',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showTaskDialog(context, widget.task),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(int.parse(widget.task.color
              .replaceAll('#', '0xff'))), // Convert hex to color
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(getIconFromString(widget.task.iconName), // TODO BITNO
                color: Colors.white,
                size: 30),
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
                      Text(formatDuration(widget.task.timeForPlayer),
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
