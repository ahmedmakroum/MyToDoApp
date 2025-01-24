  import 'package:flutter/material.dart';
  import 'package:to_do_app/widgets/category_card.dart';
  import 'dart:async';
  import '../services/database_service.dart';
  import '../models/task_model.dart'; // Ensure your Task model exists and supports fromMap
  import 'settings.dart'; // For SettingsPage
  import 'package:to_do_app/widgets/labels_and_projects_section.dart'; // For CategoriesSection

  class HomePage extends StatefulWidget {
    @override
    _HomePageState createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {
    // Timer Logic
    int totalWorkTime = 5400; // Default to 1 hour 30 minutes (in seconds)
    int remainingTime = 5400;
    double progress = 0.0;
    bool isRunning = false;
    Timer? _timer;

    // Task Data
    List<Task> tasks = [];

    @override
    void initState() {
      super.initState();
      fetchTasks();
    }

    Future<void> fetchTasks() async {
      final dbTasks = await DatabaseService().getAllTasks();
      setState(() {
        tasks = dbTasks.map((taskMap) => Task.fromMap(taskMap)).toList();
      });
    }

    @override
    void dispose() {
      _timer?.cancel();
      super.dispose();
    }

    void _startTimer() {
      if (_timer == null || !_timer!.isActive) {
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          if (remainingTime > 0 && isRunning) {
            setState(() {
              remainingTime--;
              progress = 1 - (remainingTime / totalWorkTime);
            });
          } else {
            _stopTimer();
            _showTimeUpDialog();
          }
        });
      }
      setState(() {
        isRunning = true;
      });
    }

    void _stopTimer() {
      _timer?.cancel();
      setState(() {
        isRunning = false;
      });
    }

    void _resetTimer() {
      _stopTimer();
      setState(() {
        remainingTime = totalWorkTime;
        progress = 0.0;
      });
    }

    void _showTimeUpDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Time\'s Up!'),
            content: Text('You\'ve completed your work session.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    void _showTimerSettingsDialog() {
      int selectedHours = totalWorkTime ~/ 3600;
      int selectedMinutes = (totalWorkTime % 3600) ~/ 60;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Set Timer'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Hours'),
                    DropdownButton<int>(
                      value: selectedHours,
                      items: List.generate(24, (index) => index)
                          .map((hour) => DropdownMenuItem<int>(
                                value: hour,
                                child: Text(hour.toString()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedHours = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Minutes'),
                    DropdownButton<int>(
                      value: selectedMinutes,
                      items: List.generate(60, (index) => index)
                          .map((minute) => DropdownMenuItem<int>(
                                value: minute,
                                child: Text(minute.toString()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMinutes = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    totalWorkTime = (selectedHours * 3600) + (selectedMinutes * 60);
                    remainingTime = totalWorkTime;
                    progress = 0.0;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Set'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      final int hours = remainingTime ~/ 3600;
      final int minutes = (remainingTime % 3600) ~/ 60;
      final int seconds = remainingTime % 60;

      return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Timer Display Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: isRunning ? _stopTimer : _startTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                        ),
                        child: Text(isRunning ? 'Pause' : 'Start'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _resetTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        child: Text('Reset'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showTimerSettingsDialog,
                    child: Text('Set Timer'),
                  ),
                ],
              ),
            ),

            // Progress Bar Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LinearProgressIndicator(
                value: progress > 1.0 ? 1.0 : progress,
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
              ),
            ),

            // Categories Section
            CategoriesSection(),

            // Scrollable Section for Database Tasks
            Expanded(
              child: LabelsAndProjectsSection(tasks: tasks),
            ),
          ], 
        ),
      );
    }
  }
