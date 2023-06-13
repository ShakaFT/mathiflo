import 'package:intl/intl.dart';
import 'package:mathiflo/config.dart';
import 'package:mathiflo/src/extensions/date_time_extension.dart';
import 'package:mathiflo/src/model/Calendar/calendar_event.dart';
import 'package:mathiflo/src/model/Calendar/calendar_network.dart';
import 'package:state_extended/state_extended.dart';

class CalendarController extends StateXController {
  factory CalendarController() => _this ??= CalendarController._();
  CalendarController._() : super();

  // Model
  static CalendarController? _this;

  final firstDate = DateTime.utc(2023, 06);
  final lastDate = DateTime.utc(2025, 12, 31);

  final events = <Event>[];
  final _loadedMonths = <int>[];
  DateTime _selectedDay = DateTime.now();

  DateTime get selectedDay => _selectedDay;

  void addEvent(Event event) => setState(() {
        events.add(event);
        _sortEvents();
      });

  String formattedHeaderTitle(DateTime date, String locale) {
    final formattedDate = DateFormat.yMMMM(locale).format(date);
    final firstLetter = formattedDate.substring(0, 1);
    final restOfMonth = formattedDate.substring(1);
    return '${firstLetter.toUpperCase()}${restOfMonth.toLowerCase()}';
  }

  List<Event> matchEvents(DateTime date) {
    final startDateTimestamp = date.midnight.millisecondsSinceEpoch;
    final endDateTimestamp =
        date.midnight.add(const Duration(days: 1)).millisecondsSinceEpoch;
    return events
        .where(
          (event) =>
              event.startTimestamp < endDateTimestamp &&
              event.endTimestamp > startDateTimestamp,
        )
        .toList();
  }

  Future<String> loadEvents() async {
    final firstDay = DateTime(_selectedDay.year, _selectedDay.month);
    final lastDay = DateTime(_selectedDay.year, _selectedDay.month + 1);

    if (_loadedMonths.contains(firstDay.millisecondsSinceEpoch)) return "";

    pendingAPI.value = true;
    final loadedEvents = await getNetworkEvents(
      firstDay.millisecondsSinceEpoch,
      lastDay.millisecondsSinceEpoch,
    );
    pendingAPI.value = false;

    if (loadedEvents != null) {
      _loadedMonths.add(firstDay.millisecondsSinceEpoch);
      setState(() {
        events.addAll(loadedEvents);
      });
      return "";
    }
    return "Une erreur inconnue est survenue durant le chargement des événements...";
  }

  void onDaySelected(DateTime newSelectedDay) {
    setState(() {
      _selectedDay = newSelectedDay;
    });
  }

  void removeEvent(Event event) => setState(() {
        events.remove(event);
      });

  void updateEvent(Event oldEvent, Event newEvent) => setState(() {
        // fix unknown bug
        print(newEvent.endTimestamp);
        if (newEvent.isAllDay) {
          newEvent.endTimestamp -= 24 * 3600 * 1000;
        }
        print(newEvent.endTimestamp);
        // -------------------
        events
          ..remove(oldEvent)
          ..add(newEvent);
      });

  void _sortEvents() {
    events.sort((e1, e2) {
      if (e1.startTimestamp != e2.startTimestamp) {
        return e1.startTimestamp.compareTo(e2.startTimestamp);
      }
      if (e1.endTimestamp != e2.endTimestamp) {
        return e1.endTimestamp.compareTo(e2.endTimestamp);
      }
      return e1.title.compareTo(e2.title);
    });
  }
}
