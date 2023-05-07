import 'package:intl/intl.dart';
import 'package:mathiflo/src/model/Calendar/calendar_event.dart';
import 'package:state_extended/state_extended.dart';

class CalendarController extends StateXController {
  factory CalendarController() => _this ??= CalendarController._();
  CalendarController._() : super();

  // Model
  static CalendarController? _this;

  final List<Event> events = [];
  DateTime selectedDay = DateTime.now();

  void addEvent(Event event) => setState(() {
        events.add(event);
      });

  String formattedHeaderTitle(DateTime date, String locale) {
    final formattedDate = DateFormat.yMMMM(locale).format(date);
    final firstLetter = formattedDate.substring(0, 1);
    final restOfMonth = formattedDate.substring(1);
    return '${firstLetter.toUpperCase()}${restOfMonth.toLowerCase()}';
  }

  List<Event> matchEvents(DateTime date) {
    final startDateTimestamp = date.millisecondsSinceEpoch;
    final endDateTimestamp =
        date.add(const Duration(days: 1)).millisecondsSinceEpoch - 1;
    return events
        .where(
          (event) =>
              (startDateTimestamp <= event.startTimestamp &&
                  event.startTimestamp <= endDateTimestamp) ||
              (startDateTimestamp <= event.endTimestamp &&
                  event.endTimestamp <= endDateTimestamp),
        )
        .toList();
  }

  onDaySelected(DateTime newSelectedDay) {
    selectedDay = newSelectedDay;
    setState(() {
      selectedDay = newSelectedDay;
    });
  }
}
