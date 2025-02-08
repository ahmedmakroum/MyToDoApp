class PlannerModel {
  final String id;
  final String title;
  final String description;
  String status; // "To Do", "In Progress", "Done"
  final DateTime createdAt;

  PlannerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  // You can add methods to update the task status, etc.
}