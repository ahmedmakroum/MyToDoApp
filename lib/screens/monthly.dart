import 'package:flutter/material.dart';

class MonthlyPage extends StatelessWidget {
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Vision'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: months.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MonthlyBoard(monthName: months[index]),
                ),
              );
            },
            child: Card(
              elevation: 5,
              child: Center(
                child: Text(
                  months[index],
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

class MonthlyBoard extends StatefulWidget {
  final String monthName;

  MonthlyBoard({required this.monthName});

  @override
  _MonthlyBoardState createState() => _MonthlyBoardState();
}

class _MonthlyBoardState extends State<MonthlyBoard> {
  List<String> visions = [];
  TextEditingController _controller = TextEditingController();

  void _addVision() {
    setState(() {
      visions.add(_controller.text);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.monthName} Board'),
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
                return CheckboxListTile(
                  title: Text(visions[index]),
                  value: false, // Replace this with a boolean list later if needed
                  onChanged: (value) {
                    // Future functionality for checking items
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
