import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/model/Calendar/calendar_event.dart';
import 'package:state_extended/state_extended.dart';

class AddEventController extends StateXController {
  factory AddEventController() => _this ??= AddEventController._();
  AddEventController._() : super();

  static AddEventController? _this;

  late bool _allDay;
  late DateTime _currentDay;
  late DateTime _endDate;
  late DateTime _startDate;
  late Map<String, Map<String, dynamic>> assignedUsers;
  late String titleError;

  final titleController = TextEditingController();

  void init(DateTime day) {
    _allDay = false;
    _currentDay = day;

    final now = DateTime.now();
    _endDate = DateTime(day.year, day.month, day.day, now.hour + 2);
    _startDate = DateTime(day.year, day.month, day.day, now.hour + 1);

    assignedUsers = Map<String, Map<String, dynamic>>.from(users);

    // Reset state
    titleController.text = "";
    titleError = "";
  }

  bool get allDay => _allDay;
  DateTime get endDate => _endDate;
  DateTime get startDate => _startDate;

  Event get newEvent {
    final event = Event(
      titleController.text.trim(),
      allDay
          ? _currentDay.millisecondsSinceEpoch
          : startDate.millisecondsSinceEpoch,
      allDay
          ? _currentDay.add(const Duration(days: 1)).millisecondsSinceEpoch
          : endDate.millisecondsSinceEpoch,
      assignedUsers,
    );
    return event;
  }

  set endDate(DateTime newEndDate) {
    setState(() {
      _endDate = newEndDate;
      if (_endDate.isBefore(_startDate)) {
        _startDate = _endDate.subtract(const Duration(hours: 1));
      }
    });
  }

  set startDate(DateTime newStartDate) {
    setState(() {
      _startDate = newStartDate;
      if (_startDate.isAfter(_endDate)) {
        _endDate = _startDate.add(const Duration(hours: 1));
      }
    });
  }

  String get endDateFormatted =>
      DateFormat("EEE d MMM y", "fr_FR").format(_endDate);
  String get endTimeFormatted => DateFormat("HH:mm", "fr_FR").format(_endDate);
  String get startDateFormatted =>
      DateFormat("EEE d MMM y", "fr_FR").format(_startDate);
  String get startTimeFormatted =>
      DateFormat("HH:mm", "fr_FR").format(_startDate);

  bool checkError() {
    if (titleController.text.trim().isEmpty) {
      setState(() {
        titleError = "Vous devez inscrire un titre";
      });
      return true;
    }
    return false;
  }

  void updateAllDay() {
    final now = DateTime.now();
    _endDate =
        DateTime(_endDate.year, _endDate.month, _endDate.day, now.hour + 2);
    _startDate = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      now.hour + 1,
    );
    setState(() => _allDay = !_allDay);
  }

  void updateAssignedUsers(String name, Map<String, dynamic> info) =>
      setState(() {
        assignedUsers.containsKey(name)
            ? assignedUsers.remove(name)
            : assignedUsers[name] = info;
        // sort
        assignedUsers = Map.fromEntries(
          assignedUsers.entries.toList()
            ..sort((e1, e2) => e1.key.compareTo(e2.key)),
        );
      });
}
