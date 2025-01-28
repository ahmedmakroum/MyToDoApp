class Vision {
  final int? id;
  final String title;
  final String? description;
  final String type; // "monthly" or "yearly"
  final String period; // Month name for monthly, year for yearly
  final bool isAchieved;

  Vision({
    this.id,
    required this.title,
    this.description,
    required this.type,
    required this.period,
    this.isAchieved = false,
  });

  // Convert from Map (DB) to Vision
  factory Vision.fromMap(Map<String, dynamic> map) {
    return Vision(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      type: map['type'],
      period: map['period'],
      isAchieved: map['isAchieved'] == 1,
    );
  }

  // Convert from Vision to Map (DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'period': period,
      'isAchieved': isAchieved ? 1 : 0,
    };
  }
}