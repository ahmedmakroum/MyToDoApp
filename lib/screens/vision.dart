import 'package:flutter/material.dart';
import 'monthly.dart';
import 'yearly.dart';

class VisionBoardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vision Boards'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to Monthly Vision
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MonthlyPage()),
                );
              },
              child: Text('Monthly Vision'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Yearly Vision
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YearlyPage()),
                );
              },
              child: Text('Yearly Vision'),
            ),
          ],
        ),
      ),
    );
  }
}
