import 'package:intl/intl.dart';
import 'package:state_extended/state_extended.dart';

class CalendarController extends StateXController {
  factory CalendarController() => _this ??= CalendarController._();
  CalendarController._() : super();

  // Model
  static CalendarController? _this;

  final List<Map<String, dynamic>> events = [];
  DateTime selectedDay = DateTime.now();

  String formattedHeaderTitle(DateTime date, String locale) {
    final formattedDate = DateFormat.yMMMM(locale).format(date);
    final firstLetter = formattedDate.substring(0, 1);
    final restOfMonth = formattedDate.substring(1);
    return '${firstLetter.toUpperCase()}${restOfMonth.toLowerCase()}';
  }

  matchEvents(DateTime date) => events
      .where(
        (event) => event["timestamp"] == date.millisecondsSinceEpoch,
      )
      .toList();

  onDaySelected(DateTime newSelectedDay) {
    setState(() {
      if (newSelectedDay != selectedDay) {
        selectedDay = newSelectedDay;
      } else {
        events.add({
          "title": "Événement aléatoire",
          "timestamp": newSelectedDay.millisecondsSinceEpoch
        });
      }
    });
  }
}
