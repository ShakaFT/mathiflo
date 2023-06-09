import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mathiflo/config.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/extensions/date_time_extension.dart';
import 'package:mathiflo/src/model/Calendar/calendar_event.dart';
import 'package:mathiflo/src/model/Calendar/calendar_network.dart';
import 'package:state_extended/state_extended.dart';

class HandleEventController extends StateXController {
  factory HandleEventController() => _this ??= HandleEventController._();
  HandleEventController._() : super();

  static HandleEventController? _this;

  late Event _event;
  late bool isUpdate;
  late TextEditingController titleController;
  late String titleError;

  void init(DateTime day, Event? currentEvent) {
    isUpdate = currentEvent != null;

    final now = DateTime.now();

    final endTimestamp = currentEvent == null
        ? day.midnight.add(Duration(hours: now.hour + 2)).millisecondsSinceEpoch
        : currentEvent.isAllDay
            // Substract one day
            ? currentEvent.endTimestamp - 86400000
            : currentEvent.endTimestamp;

    _event = Event(
      currentEvent?.id ?? Uuid().generateV4(),
      currentEvent?.title ?? "",
      currentEvent?.startTimestamp ??
          day.midnight
              .add(Duration(hours: now.hour + 1))
              .millisecondsSinceEpoch,
      endTimestamp,
      currentEvent?.users ?? users.keys.toList(),
    );

    titleController = TextEditingController(text: currentEvent?.title);
    titleError = "";
  }

  bool get allDay => _event.isAllDay;
  List<String> get assignedUsers => _event.users;
  DateTime get endDate => _event.endDate;
  Event get event {
    if (_event.isAllDay) {
      // Add one day
      _event.endTimestamp += 86400000;
    }
    return _event;
  }

  DateTime get startDate => _event.startDate;
  String get title =>
      isUpdate ? "Modifier l'événement" : "Ajouter un événement";

  set endDate(DateTime newEndDate) {
    setState(() {
      _event.endTimestamp = newEndDate.millisecondsSinceEpoch;
      if (_event.endTimestamp < _event.startTimestamp) {
        _event.startTimestamp = _event.endDate
            .subtract(const Duration(hours: 1))
            .millisecondsSinceEpoch;
      }
    });
  }

  set startDate(DateTime newStartDate) {
    setState(() {
      _event.startTimestamp = newStartDate.millisecondsSinceEpoch;
      if (_event.startTimestamp > _event.endTimestamp) {
        _event.endTimestamp = _event.startDate
            .add(const Duration(hours: 1))
            .millisecondsSinceEpoch;
      }
    });
  }

  String get endDateFormatted =>
      DateFormat("EEE d MMM y", "fr_FR").format(_event.endDate);
  String get endTimeFormatted =>
      DateFormat("HH:mm", "fr_FR").format(_event.endDate);
  String get startDateFormatted =>
      DateFormat("EEE d MMM y", "fr_FR").format(_event.startDate);
  String get startTimeFormatted =>
      DateFormat("HH:mm", "fr_FR").format(_event.startDate);

  Future<bool> addEvent() async {
    pendingAPI.value = true;
    final result = await addNetworkEvent(event);
    pendingAPI.value = false;
    return result;
  }

  Future<bool> updateEvent() async {
    pendingAPI.value = true;
    final result = await updateNetworkEvent(event);
    pendingAPI.value = false;
    return result;
  }

  Future<bool> deleteEvent() async {
    pendingAPI.value = true;
    final result = await deleteNetworkEvent(event);
    pendingAPI.value = false;
    return result;
  }

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
    setState(() {
      if (_event.isAllDay) {
        _event
          ..endTimestamp = _event.endTimestamp + (now.hour + 2) * 3600 * 1000
          ..startTimestamp =
              _event.startTimestamp + (now.hour + 1) * 3600 * 1000;
      } else {
        _event
          ..endTimestamp = _event.endDate.midnight.millisecondsSinceEpoch
          ..startTimestamp = _event.startDate.midnight.millisecondsSinceEpoch;
      }
    });
  }

  void updateAssignedUsers(String name) => setState(() {
        _event.users.contains(name)
            ? _event.users.remove(name)
            : _event.users.add(name);
        _event.users.sort();
      });

  void updateTitle(String newTitle) => setState(() => _event.title = newTitle);
}
