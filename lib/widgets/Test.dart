import 'package:flutter/material.dart';
import 'package:fonhakaton2025/data/databaseAPI/supabaseAPI.dart'; // Assuming your async function getGlobalTasks is in task_service.dart
import 'package:fonhakaton2025/data/new_models/task.dart'; // Assuming your async function getGlobalTasks is in task_service.dart

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late Future<List<Task>> futureTasks;

  @override
  void initState() {
    super.initState();
    // Initialize the futureTasks variable by calling the async function to get the tasks
    futureTasks = getGlobalTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Global Tasks'),
      ),
      body: FutureBuilder<List<Task>>(
        future: futureTasks, // Use the future to wait for the task data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data to load
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there is an error fetching the tasks
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If there are no tasks available
            return Center(child: Text('No tasks available'));
          } else {
            // Once data is fetched, display the tasks in a ListView
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(task.name),
                    subtitle: Text(task.description),
                    leading: Icon(task.urgent ? Icons.warning : Icons.task),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('XP: ${task.xp}'),
                        Text('People Needed: ${task.pplNeeded}'),
                      ],
                    ),
                    onTap: () {
                      // Optionally, you can navigate to a detailed view for the task
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
