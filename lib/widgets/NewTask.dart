import 'package:flutter/material.dart';
import 'task.dart'; // Import your Task model

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _xpController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  int _charCount = 0;
  String _selectedPeople = "1";
  String _selectedFaculty = "ETF";
  String _selectedLocation = "Main Hall";
  String _selectedGroup = currentUser.activeGroups.isNotEmpty
      ? currentUser.activeGroups.first
      : "None";

  final List<String> faculties = ["ETF", "FON", "MATF"];
  final List<String> locations = [
    "Main Hall",
    "Library",
    "Lab 3",
    "Classroom 101"
  ];
  final List<String> peopleOptions = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10+"
  ];

  void _createTask() {
    if (_formKey.currentState!.validate()) {
      int hours = int.tryParse(_hoursController.text) ?? 0;
      int minutes = int.tryParse(_minutesController.text) ?? 0;
      int totalMinutes = (hours * 60) + minutes;

      final newTask = Task(
        _titleController.text,
        int.parse(_xpController.text),
        totalMinutes,
        _selectedGroup,
        _selectedLocation,
        _selectedFaculty,
        0,
        _selectedPeople == "10+" ? 10 : int.parse(_selectedPeople),
        _selectedGroup == "None" || _isColorGroup(_selectedGroup),
        _descriptionController.text,
        currentUser.nickname,
      );

      setState(() {
        tasks.add(newTask);
      });

      Navigator.pop(context); // Go back after adding the task
    }
  }

  bool _isColorGroup(String group) {
    return ["Logistika", "Dnevni red", "Mediji", "Red"].contains(group);
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
                _buildTextField(_titleController, "Task Name", maxLength: 30),
                Row(
                  children: [
                    Expanded(
                        child: _buildTextField(_xpController, "XP Reward",
                            isNumber: true)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildTimeInput()), // HH:MM input
                  ],
                ),
                _buildDropdown("People Needed", peopleOptions, _selectedPeople,
                    (value) {
                  setState(() => _selectedPeople = value!);
                }),
                Row(
                  children: [
                    Expanded(
                        child: _buildDropdown(
                            "Faculty", faculties, _selectedFaculty, (value) {
                      setState(() => _selectedFaculty = value!);
                    })),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _buildDropdown(
                            "Location", locations, _selectedLocation, (value) {
                      setState(() => _selectedLocation = value!);
                    })),
                  ],
                ),
                _buildDescriptionField(),
                _buildDropdown(
                    "Group", currentUser.activeGroups, _selectedGroup, (value) {
                  setState(() => _selectedGroup = value!);
                }),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _createTask,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text("Create Task"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false, int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLength: maxLength,
        validator: (value) => value!.isEmpty ? "Enter $label" : null,
      ),
    );
  }

  Widget _buildTimeInput() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _hoursController,
            decoration: const InputDecoration(labelText: "HH"),
            keyboardType: TextInputType.number,
            maxLength: 2,
            validator: (value) {
              if (value!.isEmpty) return "Enter hours";
              int? hours = int.tryParse(value);
              if (hours == null || hours < 0 || hours > 99) {
                return "Invalid hours";
              }
              return null;
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(":"),
        ),
        Expanded(
          child: TextFormField(
            controller: _minutesController,
            decoration: const InputDecoration(labelText: "MM"),
            keyboardType: TextInputType.number,
            maxLength: 2,
            validator: (value) {
              if (value!.isEmpty) return "Enter minutes";
              int? minutes = int.tryParse(value);
              if (minutes == null || minutes < 0 || minutes > 59) {
                return "Invalid minutes";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String selected,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: selected,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: "Description"),
            maxLines: 3,
            maxLength: 100,
            onChanged: (text) {
              setState(() {
                _charCount = text.length;
              });
            },
            validator: (value) {
              if (value!.isEmpty) return "Enter description";
              return null;
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "$_charCount/100 characters",
              style:
                  TextStyle(color: _charCount > 100 ? Colors.red : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// Updated User class
class User {
  final String nickname;
  final String password;
  final List<String> activeGroups;

  User(this.nickname, this.password, this.activeGroups);
}

// Hardcoded current user
final User currentUser = User(
    "Irena", "securepassword", ["Global", "Logistika", "Dnevni red", "Mediji"]);
