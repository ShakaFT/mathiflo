import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mathiflo/constants.dart';
import 'package:state_extended/state_extended.dart';

class AddEventController extends StateXController {
  factory AddEventController() => _this ??= AddEventController._();
  AddEventController._() : super();

  static AddEventController? _this;

  late DateTime _endDate;
  late DateTime _startDate;
  late Map<String, Map<String, dynamic>> assignedUsers;

  bool _allDay = false;
  final titleController = TextEditingController();
  String titleError = "";

  void init(DateTime date) {
    final now = DateTime.now();
    _endDate = DateTime(date.year, date.month, date.day, now.hour + 2);
    _startDate = DateTime(date.year, date.month, date.day, now.hour + 1);

    assignedUsers = Map<String, Map<String, dynamic>>.from(users);

    // Reset state
    titleController.text = "";
    titleError = "";
  }

  bool get allDay => _allDay;
  DateTime get endDate => _endDate;
  DateTime get startDate => _startDate;

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

  void updateAllDay() => setState(() => _allDay = !_allDay);
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
