import 'package:flutter/material.dart';
import '../services/database_service.dart';

class MonthlyPage extends StatefulWidget {
  final String monthName; // Initial month
  MonthlyPage({required this.monthName});

  @override
  _MonthlyBoardState createState() => _MonthlyBoardState();
}

class _MonthlyBoardState extends State<MonthlyPage> {
  List<Map<String, dynamic>> visions = [];
  TextEditingController _controller = TextEditingController();
  String _selectedMonth = 'January'; // Default to January if null

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.monthName; // Initialize from widget
    _loadVisions();
  }

  Future<void> _loadVisions() async {
    try {
      final db = DatabaseService();
      final data = await db.getVisionsByPeriod(_selectedMonth, 'monthly');
      setState(() {
        visions = data;
      });
    } catch (e) {
      print('Error loading visions: $e');
    }
  }

  Future<void> _addVision() async {
    if (_controller.text.isNotEmpty) {
      try {
        final db = DatabaseService();
        final vision = {
          'title': _controller.text,
          'description': null,
          'type': 'monthly',
          'period': _selectedMonth,
          'isAchieved': 0,
        };
        print('Adding vision: $vision');
        final id = await db.addVision(vision);
        print('Vision added with ID: $id');
        _controller.clear();
        await _loadVisions(); // Reload visions after adding a new one
      } catch (e) {
        print('Error adding vision: $e');
      }
    }
  }

  Future<void> _toggleAchieved(int id, bool isAchieved) async {
    try {
      final db = DatabaseService();
      await db.updateVision(id, {'isAchieved': isAchieved ? 1 : 0});
      await _loadVisions(); // Reload visions after updating
    } catch (e) {
      print('Error toggling vision status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_selectedMonth Board'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: _selectedMonth,
            items: <String>[
              'January', 'February', 'March', 'April', 'May', 'June',
              'July', 'August', 'September', 'October', 'November', 'December'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedMonth = newValue!;
                _loadVisions();
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Add a Vision',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addVision,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: visions.length,
              itemBuilder: (context, index) {
                final vision = visions[index];
                return CheckboxListTile(
                  title: Text(vision['title']),
                  value: vision['isAchieved'] == 1,
                  onChanged: (value) {
                    _toggleAchieved(vision['id'], value ?? false);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}