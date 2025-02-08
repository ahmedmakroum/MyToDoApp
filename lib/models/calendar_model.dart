class CalendarModel {
  final DateTime date;
  final List<Event> events; // You'll likely want to define an Event model as well

  CalendarModel({
    required this.date,
    this.events = const [],
  });
}

class Event {
  final String title;
  final String description;
  final DateTime time;

  Event({
    required this.title,
    required this.description,
    required this.time,
  });
}