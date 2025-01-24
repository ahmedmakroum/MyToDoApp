import 'package:flutter/material.dart';

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
