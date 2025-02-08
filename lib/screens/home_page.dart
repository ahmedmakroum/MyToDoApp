import 'package:flutter/material.dart';
import 'package:to_do_app/screens/planner.dart';
import 'package:to_do_app/widgets/category_card.dart';
import 'dart:async';
import '../services/database_service.dart';
import '../models/task_model.dart';
import 'settings.dart'; // Import the PlannerPage

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RestorationMixin {
  // Timer Logic
  RestorableInt totalWorkTime = RestorableInt(5400); // Default
  RestorableInt remainingTime = RestorableInt(5400);
  RestorableDouble progress = RestorableDouble(0.0);
  RestorableBool isRunning = RestorableBool(false);
  Timer? _timer;

  // Task Data
  List<Task> tasks = [];

  @override
  String? get restorationId => 'home_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(totalWorkTime, 'total_work_time');
    registerForRestoration(remainingTime, 'remaining_time');
    registerForRestoration(progress, 'progress');
    registerForRestoration(isRunning, 'is_running');
  }

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      final dbTasks = await DatabaseService().getAllTasks();
      setState(() {
        tasks = dbTasks.map((taskMap) => Task.fromMap(taskMap)).toList();
      });
    } catch (e) {
      print('Error fetching tasks: $e');
      // Handle the error appropriately (e.g., show an error message)
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    totalWorkTime.dispose();
    remainingTime.dispose();
    progress.dispose();
    isRunning.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (remainingTime.value > 0 && isRunning.value) {
          setState(() {
            remainingTime.value--;
            progress.value = 1 - (remainingTime.value / totalWorkTime.value);
          });
        } else {
          _stopTimer();
          _showTimeUpDialog();
        }
      });
    }
    setState(() {
      isRunning.value = true;
    });
  }

  void _stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    setState(() {
      isRunning.value = false;
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      remainingTime.value = totalWorkTime.value;
      progress.value = 0.0;
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
    int selectedHours = totalWorkTime.value ~/ 3600;
    int selectedMinutes = (totalWorkTime.value % 3600) ~/ 60;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Set Timer'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedHours = newValue;
                            });
                          }
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
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedMinutes = newValue;
                            });
                          }
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
                      totalWorkTime.value = (selectedHours * 3600) + (selectedMinutes * 60);
                      remainingTime.value = totalWorkTime.value;
                      progress.value = 0.0;
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int hours = remainingTime.value ~/ 3600;
    final int minutes = (remainingTime.value % 3600) ~/ 60;
    final int seconds = remainingTime.value % 60;

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
                      onPressed: isRunning.value ? _stopTimer : _startTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                      ),
                      child: Text(isRunning.value ? 'Pause' : 'Start'),
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
              value: progress.value > 1.0 ? 1.0 : progress.value,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
          ),

          // Categories Section
          CategoriesSection(navigateToPlanner: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlannerPage()),
            );
          }),

          // Expandable Lists Section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildExpandableList("Projects", ["Project A", "Project B", "Project C"]),
                  _buildExpandableList("Labels (Work, Life, Habits...)", ["Work", "Life", "Habits"]),
                  _buildExpandableList("Status (Done, To Do)", ["Done", "To Do"]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableList(String title, List<String> items) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: items.map((item) => ListTile(title: Text(item))).toList(),
    );
  }
}

// Category Section code
class CategoriesSection extends StatelessWidget {
  final VoidCallback navigateToPlanner;

  CategoriesSection({required this.navigateToPlanner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCategoryCard(context, "To-Do List", Icons.checklist),
          _buildCategoryCard(context, "Calendar", Icons.calendar_today),
          _buildCategoryCard(context, "Planner", Icons.view_week, navigateToPlanner: navigateToPlanner),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, {VoidCallback? navigateToPlanner}) {
    return GestureDetector(
      onTap: () {
        if (title == "Planner" && navigateToPlanner != null) {
          navigateToPlanner();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title selected')),
          );
        }
      },
      child: Card(
        elevation: 4,
        child: Container(
          width: 100,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}