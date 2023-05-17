import 'package:intl/intl.dart';

class Event {
  Event(this.title, this.startTimestamp, this.endTimestamp, this.users);
  String title;
  int startTimestamp;
  int endTimestamp;
  Map<String, Map<String, dynamic>> users;

  DateTime get endDate => DateTime.fromMillisecondsSinceEpoch(endTimestamp);
  DateTime get startDate => DateTime.fromMillisecondsSinceEpoch(startTimestamp);

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
}
