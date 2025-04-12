import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fonhakaton2025/data/global.dart';
import 'package:fonhakaton2025/data/models/task.dart';
import 'package:fonhakaton2025/data/supabase_helper.dart';
import 'package:fonhakaton2025/utils/IconConverter.dart';
import 'package:fonhakaton2025/data/databaseAPI/supabaseAPI.dart';

class NewTaskScreen extends StatefulWidget {
  final int group_id;

  const NewTaskScreen({super.key, required this.group_id});

  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
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

  // Task? _selectedPredefinedTask;
  Map<String, dynamic> noitem = {"name": "none", "selected": false};
  Color _selectedColor = Colors.blue;
  bool _showAdditionalOptions = false;
  int _selectedPredefinedTask = 0;
  bool _isPredefinedSelected = false;

  final List<Map<String, dynamic>> predefinedTasksList = [];
  final List<DropdownMenuItem<int>> dropdownList = [];

  @override
  void initState() {
    super.initState();

    // form list of tasks
    predefinedTasksList.add(noitem);
    predefinedTasksList.addAll(Global.getPredeterminedTasks()!
        .where((task) => task['for_group'] as int == widget.group_id));
    for (var i = 0; i < predefinedTasksList.length; i++) {
      dropdownList.add(DropdownMenuItem(
          value: i, child: Text(predefinedTasksList[i]['name'])));
    }

    // update logic
    _selectedPredefinedTask = 0; // index of first element of list
  }

  void selectPredefined(int idx) {
    if (idx == 0) {
      _isPredefinedSelected = false;
      resetControllerValues();
      return;
    }
    _isPredefinedSelected = true; // todo check out of bounds??
    _selectedPredefinedTask = idx;
    setControllerPredefValues();
  }

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

  void setControllerPredefValues() {
    Map<String, dynamic> task = predefinedTasksList[_selectedPredefinedTask];

    _titleController.text = task['name'];
    _xpController.text = task['xp'].toString();

    _hoursController.text = (task['exists_for_time'] ~/ 60).toString();
    _minutesController.text = (task['exists_for_time'] % 60).toString();
    _peopleController.text = task['ppl_needed'].toString();
    _locationController.text = task['place'];
    _descriptionController.text = task['description'];
    print("setControllerPredefValues : ${task['description']}");
    // todo: take uni and URGENT info from task from the list...
  }

  void resetControllerValues() {
    _titleController.text = "";
    _xpController.text = "";

    _hoursController.text = "";
    _minutesController.text = "";
    _peopleController.text = "";
    _locationController.text = "";
    _descriptionController.text = "";
  }
  // void _setTaskFields(Map<String, dynamic> task) {
  //   setState(() {
  //     _titleController.text = task['name'];
  //     _xpController.text = task['xp']
  //         .toString(); // todo check for err? return " " by default or smth
  //     // _durationController.text =
  //     //     (task.durationMinutes ~/ 60).toString(); // Convert to hours

  //     _hoursController.text = (task['exists_for_time'] ~/ 60).toString();
  //     _minutesController.text = (task['exists_for_time'] % 60).toString();
  //     _peopleController.text = task['ppl_needed'].toString();
  //     _locationController.text = task['place'];
  //     _descriptionController.text = task['description'];
  //     // todo: take uni and URGENT info from task from the list...
  //   });
  // }

  void _createTask() async {
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

      // create new Task entry!

      final newTask = Task(
        taskId: 1, // This should be handled by the backend
        name: _titleController.text,
        description: _descriptionController.text,
        place:
            _locationController.text.isEmpty ? "ETF" : _locationController.text,
        uniId:
            Global.user!.uniId, // Should be set with actual university ID apr12
        xp: int.parse(_xpController.text),
        groupId: widget.group_id, // Optional group ID
        urgent: false, // Set according to your needs apr12 todo
        existsForTime:
            0, // how long the task should globally exist -> todo maybe make the task maker able to decide?
        pplNeeded: _peopleController.text.isEmpty
            ? 1
            : int.parse(_peopleController.text),
        pplDoing: 0, // Initially 0
        pplSubmitted: 0, // Initially 0
        createdBy:
            Global.getUsername(), // This should be set with actual user ID
        color:
            '#${_selectedColor.value.toRadixString(16).substring(2)}', // Convert Color to hex string
        iconName: iconToString(iconData),
        timeForPlayer: duration, // apr12 what is this??
      );

      int createdTaskId = await createTask(newTask);
      print("created task id : $createdTaskId");

      if (_isPredefinedSelected && createdTaskId != -1) {
        // add predetermined_existing entry -> will be used to assign stat points upon completion!
        await createPredeterminedExisting(Global.getUsername(), createdTaskId,
            predefinedTasksList[_selectedPredefinedTask]['pred_id']);
      }

      // setState(() {
      //   //tasks.add(newTask);
      //   //TODO
      // });

      // insertTask(newTask);

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
                      DropdownButtonFormField<int>(
                        value: _selectedPredefinedTask,
                        items: dropdownList,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectPredefined(value));
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
                              enabled: (_isPredefinedSelected == false),
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
                              enabled: (_isPredefinedSelected == false),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _minutesController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: "Minuti"),
                              enabled: (_isPredefinedSelected == false),
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
                              enabled: (_isPredefinedSelected == false),
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
                                    maxLength: 500,
                                    controller: _peopleController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: "Broj ljudi"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    maxLength: 30,
                                    controller: _locationController,
                                    decoration: const InputDecoration(
                                        labelText: "Lokacija"),
                                    enabled: (_isPredefinedSelected == false),
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
                              enabled: (_isPredefinedSelected == false),
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
