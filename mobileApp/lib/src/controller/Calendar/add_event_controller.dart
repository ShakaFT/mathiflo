import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mathiflo/constants.dart';
import 'package:state_extended/state_extended.dart';

class AddEventController extends StateXController {
  factory AddEventController() => _this ??= AddEventController._();
  AddEventController._() : super();

  static AddEventController? _this;

  late DateTime endDate;
  late DateTime startDate;
  late Map<String, Map<String, dynamic>> assignedUsers;

  bool _allDay = false;
  final titleController = TextEditingController();

  void init(DateTime date) {
    final now = DateTime.now();
    endDate = DateTime(date.year, date.month, date.day, now.hour + 2);
    startDate = DateTime(date.year, date.month, date.day, now.hour + 1);

    assignedUsers = Map<String, Map<String, dynamic>>.from(users);
  }

  bool get allDay => _allDay;

  String get endDateFormatted =>
      DateFormat("EEE d MMM y", "fr_FR").format(endDate);
  String get endTimeFormatted => DateFormat("HH:mm", "fr_FR").format(endDate);
  String get startDateFormatted =>
      DateFormat("EEE d MMM y", "fr_FR").format(startDate);
  String get startTimeFormatted =>
      DateFormat("HH:mm", "fr_FR").format(startDate);

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
