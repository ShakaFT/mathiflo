import 'package:intl/intl.dart';

class Event {
  Event(this.title, this.startTimestamp, this.endTimestamp, this.users);
  String title;
  int startTimestamp;
  int endTimestamp;
  Map<String, Map<String, dynamic>> users;

  DateTime get endDate => DateTime.fromMillisecondsSinceEpoch(endTimestamp);
  DateTime get startDate => DateTime.fromMillisecondsSinceEpoch(startTimestamp);

  bool isAllDay(DateTime currentDate) {
    final currentTimestamp = currentDate.millisecondsSinceEpoch;
    final timestampNextDay =
        currentDate.add(const Duration(days: 1)).millisecondsSinceEpoch;
    return startTimestamp <= currentTimestamp &&
        endTimestamp >= timestampNextDay;
  }

  String timeToDisplay(DateTime currentDate) {
    final startTimeString = DateFormat('HH:mm').format(startDate);
    final endTimeString = DateFormat('HH:mm').format(endDate);

    return isAllDay(currentDate)
        ? "Jour entier"
        : "$startTimeString\n$endTimeString";
  }
}
