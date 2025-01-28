class Event {
  final int? id;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime? endDate;

  Event({
    this.id,
    required this.title,
    this.description,
    required this.startDate,
    this.endDate,
  });

  // Convert from Map (DB) to Event
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startDate: DateTime.parse(map['startDate']),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    );
  }

  // Convert from Event to Map (DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}