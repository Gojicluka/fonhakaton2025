

import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle "Suggest a Feature" button press
              },
              child: Text('Suggest a Feature'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle "Report Player" button press
              },
              child: Text('Report Player'),
            ),
          ],
        ),
      ),
    );
  }
}