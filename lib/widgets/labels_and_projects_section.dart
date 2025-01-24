import 'package:flutter/material.dart';
import '../models/task_model.dart';

class LabelsAndProjectsSection extends StatelessWidget {
  final List<Task> tasks;

  // Constructor to accept tasks
  LabelsAndProjectsSection({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tasks.map((task) => _buildTaskCard(task)).toList(),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(Icons.task, color: Colors.blueAccent),
        title: Text(task.title), // Use the `title` field of the task
        subtitle: Text(task.description ?? "No description"), // Handle null values for description
        trailing: Icon(Icons.arrow_forward, color: Colors.grey),
        onTap: () {
          // Add functionality here, e.g., navigate to task details
        },
      ),
    );
  }
}

