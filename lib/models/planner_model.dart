class PlannerItem {
  final int? id;
  final String title;
  final String? description;
  final String status; // "To Do", "In Progress", "Done"
  final DateTime createdAt;

  PlannerItem({
    this.id,
    required this.title,
    this.description,
    required this.status,
    required this.createdAt,
  });

  // Convert from Map (DB) to PlannerItem
  factory PlannerItem.fromMap(Map<String, dynamic> map) {
    return PlannerItem(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Convert from PlannerItem to Map (DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}