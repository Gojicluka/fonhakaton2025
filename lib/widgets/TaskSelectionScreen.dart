import 'package:flutter/material.dart';

class TaskSelectionScreen extends StatefulWidget {
  @override
  _TaskSelectionScreenState createState() => _TaskSelectionScreenState();
}

class _TaskSelectionScreenState extends State<TaskSelectionScreen> {
  // Hardcoded list of groups the user belongs to
  final List<String> userGroups = ["Logistika", "Mediji"];

  String? selectedGroup; // Stores the selected group

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // First half - Global Task Button
            Container(
              height: MediaQuery.of(context).size.height * 0.40,
              width: double.infinity,
              color: Colors.blueAccent,
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  // Handle "Global" selection TODO
                  // open PublicTaskPage.
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  textStyle:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("GLOBAL"),
              ),
            ),

            // Second half - Group Selection
            Container(
              height: MediaQuery.of(context).size.height * 0.60,
              width: double.infinity,
              color: Colors.orangeAccent,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // First row - Instruction Text
                  Text(
                    "Ili izaberite jednu od svojih grupa:",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  // Second row - Dropdown Menu
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedGroup,
                        hint: Text("Izaberite grupu"),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGroup = newValue;
                          });
                        },
                        items: userGroups.map((String group) {
                          return DropdownMenuItem<String>(
                            value: group,
                            child: Text(group),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Third row - "Pogledaj" Button
                  ElevatedButton(
                    onPressed: selectedGroup != null
                        ? () {
                            // Handle group selection TODO
                            // remember group selected in a global variable, which you will use to display tasks in the GroupTaskPage.
                          }
                        : null, // Disable button if no group is selected
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedGroup != null ? Colors.white : Colors.grey,
                      foregroundColor: Colors.orangeAccent,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      textStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Pogledaj"),
                  ),

                  // Extra margin for scrolling
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
