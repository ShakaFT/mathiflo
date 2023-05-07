import 'package:mathiflo/src/controller/Calendar/calendar_controller.dart';
import 'package:mathiflo/src/model/Calendar/calendar_event.dart';
import 'package:state_extended/state_extended.dart';

class EventPopupController extends StateXController {
  factory EventPopupController() => _this ??= EventPopupController._();
  EventPopupController._() : super();

  static EventPopupController? _this;

  late CalendarController calendarController;
  late DateTime date;
  late List<Event> events;
}
