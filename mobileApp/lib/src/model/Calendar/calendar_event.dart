import 'package:intl/intl.dart';
import 'package:mathiflo/src/extensions/date_time_extension.dart';

class Event {
  Event(
    this.id,
    this.title,
    this.startTimestamp,
    this.endTimestamp,
    this.users,
  );
  String id;
  String title;
  int startTimestamp;
  int endTimestamp;
  List<String> users;

  DateTime get endDate => DateTime.fromMillisecondsSinceEpoch(endTimestamp);
  DateTime get startDate => DateTime.fromMillisecondsSinceEpoch(startTimestamp);

  bool get isAllDay =>
      startDate.midnight == startDate && endDate.midnight == endDate;

  bool get isMultipleDays =>
      startDate.year != endDate.year ||
      startDate.month != endDate.month ||
      startDate.day != endDate.subtract(const Duration(milliseconds: 1)).day;

  String timeToDisplay(DateTime currentDate) {
    final startTimeString =
        startDate.millisecondsSinceEpoch <= currentDate.millisecondsSinceEpoch
            ? "00:00"
            : DateFormat('HH:mm').format(startDate);
    final endTimeString = endDate.millisecondsSinceEpoch >=
            currentDate.add(const Duration(days: 1)).millisecondsSinceEpoch
        ? "00:00"
        : DateFormat('HH:mm').format(endDate);

    return startTimeString == "00:00" && endTimeString == "00:00"
        ? "Jour entier"
        : "$startTimeString\n$endTimeString";
  }

  static Event fromMap(Map<String, dynamic> map) => Event(
        map["id"],
        map["title"],
        map["start_timestamp"],
        map["end_timestamp"],
        List<String>.from(map["users"]),
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "start_timestamp": startTimestamp,
        "end_timestamp": endTimestamp,
        "users": users,
      };
}
