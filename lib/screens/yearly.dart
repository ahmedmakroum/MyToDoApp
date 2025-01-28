import 'package:flutter/material.dart';
import 'package:to_do_app/services/database_service.dart'; // Import your DatabaseService

class YearlyPage extends StatelessWidget {
  final List<int> years = [2025, 2026, 2027, 2028, 2029, 2030];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yearly Vision'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: years.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => YearlyBoard(year: years[index]),
                ),
              );
            },
            child: Card(
              elevation: 5,
              child: Center(
                child: Text(
                  years[index].toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class YearlyBoard extends StatefulWidget {
  final int year;

  YearlyBoard({required this.year});

  @override
  _YearlyBoardState createState() => _YearlyBoardState();
}

class _YearlyBoardState extends State<YearlyBoard> {
  List<Map<String, dynamic>> visions = []; // Store visions from the database
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadVisions(); // Load visions from the database when the screen initializes
  }

  Future<void> _loadVisions() async {
    final db = DatabaseService();
    final data = await db.getVisionsByPeriod(widget.year.toString(), 'yearly');
    setState(() {
      visions = data;
    });
  }

  Future<void> _addVision() async {
    if (_controller.text.isNotEmpty) {
      final db = DatabaseService();
      await db.addVision({
        'title': _controller.text,
        'description': null,
        'type': 'yearly',
        'period': widget.year.toString(),
        'isAchieved': 0,
      });
      _controller.clear();
      _loadVisions(); // Reload visions after adding a new one
    }
  }

  Future<void> _toggleAchieved(int id, bool isAchieved) async {
    final db = DatabaseService();
    await db.updateVision(id, {'isAchieved': isAchieved ? 1 : 0});
    _loadVisions(); // Reload visions after updating
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.year} Board'),
      ),
      body: Column(
        children: [
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