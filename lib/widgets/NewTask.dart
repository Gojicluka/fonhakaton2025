import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fonhakaton2025/data/global.dart';
import 'package:fonhakaton2025/data/models/task.dart';
import 'package:fonhakaton2025/data/supabase_helper.dart';
import 'package:fonhakaton2025/widgets/icon_converter.dart';

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

  // dodato

  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  Task? _selectedPredefinedTask;
  Color _selectedColor = Colors.blue;
  bool _showAdditionalOptions = false;

  final List<Task> predefinedTasks = [
    Task(
      id: 0,
      creatorId: null,
      durationMinutes: 0,
      xpGain: 0,
      done: false,
      studentGroupId: null,
      universityId: 1,
      location: "",
      peopleNeeded: 0,
      isPublic: false,
      title: "Nijedan",
      description: "",
      peopleApplied: 0,
      color: '#9E9E9E',
    ),
    Task(
      id: 1,
      creatorId: 1,
      durationMinutes: 60,
      xpGain: 50,
      studentGroupId: 1,
      universityId: 1,
      location: "Glavna sala",
      peopleNeeded: 3,
      isPublic: true,
      title: "Deljenje letaka",
      description: "Deljenje letaka na ključnim lokacijama.",
      peopleApplied: 0,
      color: '#2196F3',
    ),
    Task(
      id: 2,
      creatorId: 1,
      durationMinutes: 120,
      xpGain: 100,
      studentGroupId: 2,
      universityId: 1,
      location: "Recepcija",
      peopleNeeded: 5,
      isPublic: true,
      title: "Pomoć pri registraciji",
      description: "Pomoć pri prijavljivanju učesnika.",
      peopleApplied: 0,
      color: '#4CAF50',
    ),
    Task(
      id: 3,
      creatorId: 1,
      durationMinutes: 90,
      xpGain: 80,
      studentGroupId: 2,
      universityId: 1,
      location: "Skladište",
      peopleNeeded: 2,
      isPublic: true,
      title: "Organizovanje opreme",
      description: "Sortiranje i distribucija opreme.",
      peopleApplied: 0,
      color: '#FF9800',
    ),
    Task(
      id: 4,
      creatorId: 1,
      durationMinutes: 75,
      xpGain: 60,
      studentGroupId: 3,
      universityId: 1,
      location: "Hol",
      peopleNeeded: 4,
      isPublic: true,
      title: "Vođenje posetilaca",
      description: "Pomoć posetiocima da pronađu svoj put.",
      peopleApplied: 0,
      color: '#9C27B0',
    ),
  ];

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Izaberite boju"),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _selectedColor,
            availableColors: [
              Color(int.parse('0xFF795548')), // Logistika brown
              Color(int.parse('0xFF607D8B')), // Dnevni red blue grey
              Color(int.parse('0xFF673AB7')), // Mediji deep purple
              Color(int.parse('0xFFF44336')), // Red red
              Color(int.parse('0xFF2196F3')), // Blue blue
              Color(int.parse('0xFFE91E63')), // Pink pink
            ],
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
      _xpController.text = task.xpGain.toString();
      // _durationController.text =
      //     (task.durationMinutes ~/ 60).toString(); // Convert to hours

      _hoursController.text = (task.durationMinutes ~/ 60).toString();
      _minutesController.text = (task.durationMinutes % 60).toString();
      _peopleController.text = task.peopleNeeded.toString();
      _locationController.text = task.location;
    });
  }

  void _createTask() {
    if (_formKey.currentState!.validate()) {
      final int hours = int.tryParse(_hoursController.text) ?? 0;
      final int minutes = int.tryParse(_minutesController.text) ?? 0;
      final int duration = (hours * 60) + minutes;

      IconData iconData = Icons.task;

      switch (_selectedColor.value.toRadixString(16).substring(2)) {
        case '795548':
          iconData = Icons.shield;
          break;
        case '607D8B':
          iconData = Icons.schedule;
          break;
        case '673AB7':
          iconData = Icons.auto_awesome;
          break;
        case 'c':
          iconData = Icons.local_fire_department;
          break;
        case '2196F3':
          iconData = Icons.water;
          break;
        case 'E91E63':
          iconData = Icons.local_florist;
          break;
        default:
          iconData = Icons.task;
          break;
      }

      final newTask = Task(
        id: 0, // This should be handled by the backend
        creatorId: Global.user!.id, // This should be set with actual user ID
        durationMinutes: duration,
        xpGain: int.parse(_xpController.text),
        studentGroupId: null, // Optional student group ID
        universityId: 1, // Should be set with actual university ID
        location:
            _locationController.text.isEmpty ? "ETF" : _locationController.text,
        peopleNeeded: _peopleController.text.isEmpty
            ? 1
            : int.parse(_peopleController.text),
        isPublic: false, // Set according to your needs
        title: _titleController.text,
        description: _descriptionController.text,
        peopleApplied: 0, // Initially 0
        iconName: iconToString(iconData),
        color:
            '#${_selectedColor.value.toRadixString(16).substring(2)}', // Convert Color to hex string
      );

      setState(() {
        //tasks.add(newTask);
        //TODO
      });
      SupabaseHelper.insertTask(newTask);

      Navigator.of(context).pop();

      // Show alert dialog with task details
      // showDialog(
      //   context: context, // Make sure context is correct
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: const Text("Task Created"),
      //       content: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text("Title: ${newTask.title}"),
      //           Text("XP: ${newTask.xpGain}"),
      //           Text("Duration: ${newTask.durationMinutes} min"),
      //           Text("Group: ${newTask.studentGroupId}"),
      //           Text("Location: ${newTask.location}"),
      //           Text("Faculty: ${newTask.universityId}"),
      //           Text("Needed People: ${newTask.peopleNeeded}"),
      //           Text("Public: ${newTask.isPublic ? "Yes" : "No"}"),
      //           Text("Description: ${newTask.description}"),
      //           Text("Created by: ${newTask.creatorId}"),
      //           Container(
      //             width: 50,
      //             height: 20,
      //             color:
      //                 Color(int.parse(newTask.color.replaceAll('#', '0xff'))),
      //           ),
      //         ],
      //       ),
      //       actions: [
      //         TextButton(
      //           onPressed: () => Navigator.of(context).pop(),
      //           child: const Text("OK"),
      //         ),
      //       ],
      //     );
      //   },
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Napravi novi zadatak")),
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
                      const Text("Selektujte iz predefinisanih zadataka: ",
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
                        decoration: const InputDecoration(labelText: "Zadatak"),
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
                      const Text("Ili napravite svoj zadatak:",
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),

                      // Task Name & Color Picker
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _titleController,
                              maxLength: 30,
                              decoration: const InputDecoration(
                                  labelText: "Ime zadatka"),
                              validator: (value) =>
                                  value!.isEmpty ? "Unesite ime zadatka" : null,
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
                      // Duration & XP Gain
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _hoursController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: "Sati"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _minutesController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: "Minuti"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _xpController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: "XP dobit"),
                              validator: (value) =>
                                  value!.isEmpty ? "Unesite XP" : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() =>
                              _showAdditionalOptions = !_showAdditionalOptions);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Dodatne opcije",
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
                                        labelText: "Broj ljudi"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _locationController,
                                    decoration: const InputDecoration(
                                        labelText: "Lokacija"),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _descriptionController,
                              maxLength: 80,
                              decoration: const InputDecoration(
                                labelText: "Opis",
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
                            child: const Text("Napravite zadatak"),
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
