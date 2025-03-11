import 'package:flutter/material.dart';
import 'task.dart'; // Import your Task model
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _xpController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Task? _selectedPredefinedTask;
  Color _selectedColor = Colors.blue;
  bool _showAdditionalOptions = false;

  final List<Task> predefinedTasks = [
    Task("None", 0, 0, "", "", "", 0, 0, false, "", "", Colors.grey),
    Task("Distribute Flyers", 50, 60, "Marketing", "Main Hall", "ETF", 0, 3,
        true, "Hand out flyers at key locations.", "Admin", Colors.blue),
    Task("Help at Registration", 100, 120, "Logistics", "Front Desk", "ETF", 0,
        5, true, "Assist in checking in attendees.", "Admin", Colors.green),
    Task("Organize Equipment", 80, 90, "Logistics", "Storage Room", "ETF", 0, 2,
        true, "Sort and distribute equipment.", "Admin", Colors.orange),
    Task("Guide Visitors", 60, 75, "Public Relations", "Lobby", "ETF", 0, 4,
        true, "Help visitors find their way.", "Admin", Colors.purple),
  ];

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Task Color"),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() {
                _selectedColor = color;
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void _setTaskFields(Task task) {
    setState(() {
      _titleController.text = task.title;
      _xpController.text = task.xp.toString();
      _durationController.text =
          (task.durationMinutes ~/ 60).toString(); // Convert to hours
      _peopleController.text = task.neededPeople.toString();
      _locationController.text = task.location;
    });
  }

  // void _createTask() {
  //   if (_formKey.currentState!.validate()) {
  //     final int duration = int.parse(_durationController.text) * 60;
  //     final newTask = Task(
  //       _titleController.text,
  //       int.parse(_xpController.text),
  //       duration,
  //       "Custom", // todo GROUP NAME
  //       _locationController.text.isEmpty ? "ETF" : _locationController.text,
  //       "ETF", // todo SHOULD READ FROM USER
  //       0,
  //       _peopleController.text.isEmpty ? 1 : int.parse(_peopleController.text),
  //       false, // if group exists
  //       _descriptionController.text,
  //       "User",
  //       _selectedColor, // Read selected color
  //     );
  //     setState(() {
  //       tasks.add(newTask);
  //     });

  //     void _createTask() {
  //       if (_formKey.currentState!.validate()) {
  //         final int duration = int.parse(_durationController.text) * 60;
  //         final newTask = Task(
  //           _titleController.text,
  //           int.parse(_xpController.text),
  //           duration,
  //           "Custom", // todo GROUP NAME
  //           _locationController.text.isEmpty ? "ETF" : _locationController.text,
  //           "ETF", // todo SHOULD READ FROM USER
  //           0,
  //           _peopleController.text.isEmpty
  //               ? 1
  //               : int.parse(_peopleController.text),
  //           false, // if group exists
  //           _descriptionController.text,
  //           "User",
  //           _selectedColor, // Read selected color
  //         );

  //         setState(() {
  //           tasks.add(newTask);

  void _createTask() {
    if (_formKey.currentState!.validate()) {
      final int duration = int.parse(_durationController.text) * 60;
      final newTask = Task(
        _titleController.text,
        int.parse(_xpController.text),
        duration,
        "Custom", // TODO: GROUP NAME
        _locationController.text.isEmpty ? "ETF" : _locationController.text,
        "ETF", // TODO: SHOULD READ FROM USER
        0,
        _peopleController.text.isEmpty ? 1 : int.parse(_peopleController.text),
        false, // if group exists
        _descriptionController.text,
        "User",
        _selectedColor, // Read selected color
      );

      setState(() {
        tasks.add(newTask);
      });

      // Show alert dialog with task details
      showDialog(
        context: context, // Make sure context is correct
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Task Created"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Title: ${newTask.title}"),
                Text("XP: ${newTask.xp}"),
                Text("Duration: ${newTask.durationMinutes} min"),
                Text("Group: ${newTask.groupName}"),
                Text("Location: ${newTask.location}"),
                Text("Faculty: ${newTask.faculty}"),
                Text("Needed People: ${newTask.neededPeople}"),
                Text("Public: ${newTask.isPublic ? "Yes" : "No"}"),
                Text("Description: ${newTask.description}"),
                Text("Created by: ${newTask.createdBy}"),
                Container(
                  width: 50,
                  height: 20,
                  color: newTask.color,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create New Task")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Predefined Task Selection
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text("Select from predefined tasks",
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<Task>(
                        value: _selectedPredefinedTask,
                        items: predefinedTasks
                            .map((task) => DropdownMenuItem(
                                  value: task,
                                  child: Text(task.title),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _setTaskFields(value);
                            setState(() => _selectedPredefinedTask = value);
                          }
                        },
                        decoration: const InputDecoration(labelText: "Task"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Custom Task Creation
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Or create a custom task:",
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),

                      // Task Name & Color Picker
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _titleController,
                              maxLength: 30,
                              decoration:
                                  const InputDecoration(labelText: "Task Name"),
                              validator: (value) =>
                                  value!.isEmpty ? "Enter Task Name" : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _pickColor,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _selectedColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Duration & XP Gain
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _durationController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: "Duration (hours)"),
                              validator: (value) =>
                                  value!.isEmpty ? "Enter duration" : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _xpController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: "XP Gain"),
                              validator: (value) =>
                                  value!.isEmpty ? "Enter XP" : null,
                            ),
                          ),
                        ],
                      ),

                      // Expandable Additional Options
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() =>
                              _showAdditionalOptions = !_showAdditionalOptions);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Additional options",
                                style: TextStyle(fontSize: 18)),
                            Icon(
                              _showAdditionalOptions
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                            ),
                          ],
                        ),
                      ),
                      if (_showAdditionalOptions)
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _peopleController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: "People Needed"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _locationController,
                                    decoration: const InputDecoration(
                                        labelText: "Location"),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _descriptionController,
                              maxLength: 80,
                              decoration: const InputDecoration(
                                labelText: "Description",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? "Enter a description" : null,
                            ),
                          ],
                        ),

                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20), // Adjust as needed
                        child: Center(
                          child: ElevatedButton(
                            onPressed: _createTask,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            child: const Text("Create Task"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
