import 'package:flutter/material.dart';
import 'package:fonhakaton2025/data/global.dart';
import 'package:fonhakaton2025/screens/NewTaskScreen.dart';

class NewTaskChoiceScreen extends StatefulWidget {
  @override
  _NewTaskChoiceScreenState createState() => _NewTaskChoiceScreenState();
}

class _NewTaskChoiceScreenState extends State<NewTaskChoiceScreen> {
  // Hardcoded list of groups the user belongs to todo change
  // final List<String> userGroups = ["Logistika", "Mediji"];
  final List<Map<String, dynamic>>? userGroups = Global.getUserGroups();

  int selectedGroup = GroupCode.JAVNO.index; // Stores the selected group

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewTaskScreen(
                            group_id:
                                GroupCode.JAVNO.index)), // group id for JAVNO
                  );
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
                child: Text("JAVNO"),
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
                      child: DropdownButton<int>(
                        value: selectedGroup,
                        hint: Text("Izaberite grupu"),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        onChanged: (int? newValue) {
                          setState(() {
                            if (newValue != null) {
                              selectedGroup = newValue;
                            }
                          });
                        },
                        items: userGroups?.map((dynamic group) {
                          return DropdownMenuItem<int>(
                            value: group['group_id'] as int,
                            child: Text(group['name']),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Third row - "Pogledaj" Button
                  ElevatedButton(
                    onPressed: selectedGroup != GroupCode.JAVNO.index
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NewTaskScreen(group_id: selectedGroup)),
                            );
                          }
                        : null,
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
