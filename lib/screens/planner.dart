import 'package:flutter/material.dart';
import 'package:to_do_app/models/planner_model.dart';


class PlannerPage extends StatefulWidget {
  @override
  _PlannerPageState createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  // Sample Data (Replace with your data source - database, API, etc.)
  List<PlannerModel> tasks = [
    PlannerModel(id: '1', title: 'Task 1', description: 'Description 1', status: 'To Do', createdAt: DateTime.now()),
    PlannerModel(id: '2', title: 'Task 2', description: 'Description 2', status: 'In Progress', createdAt: DateTime.now()),
    PlannerModel(id: '3', title: 'Task 3', description: 'Description 3', status: 'Done', createdAt: DateTime.now()),
    PlannerModel(id: '4', title: 'Task 4', description: 'Description 4', status: 'To Do', createdAt: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planner'),
      ),
      body: Row(
        children: [
          _buildColumn(context, 'To Do'),
          _buildColumn(context, 'In Progress'),
          _buildColumn(context, 'Done'),
        ],
      ),
    );
  }

  Widget _buildColumn(BuildContext context, String status) {
    List<PlannerModel> columnTasks = tasks.where((task) => task.status == status).toList();

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              status,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: columnTasks.length,
              itemBuilder: (context, index) {
                final task = columnTasks[index];
                return _buildTaskCard(context, task);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, PlannerModel task) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(task.description),
          ],
        ),
      ),
    );
  }
}