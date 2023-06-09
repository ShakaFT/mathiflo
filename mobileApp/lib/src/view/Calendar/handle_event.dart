import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/controller/Calendar/event_popup_controller.dart';
import 'package:mathiflo/src/controller/Calendar/handle_event_controller.dart';
import 'package:mathiflo/src/model/Calendar/calendar_event.dart';
import 'package:mathiflo/src/widgets/async.dart';
import 'package:mathiflo/src/widgets/bar.dart';
import 'package:mathiflo/src/widgets/popups.dart';
import 'package:mathiflo/src/widgets/texts.dart';
import 'package:state_extended/state_extended.dart';

class HandleEventView extends StatefulWidget {
  const HandleEventView({
    super.key,
    required this.popupController,
    required this.date,
    this.event,
  });

  final DateTime date;
  final Event? event;
  final EventPopupController popupController;

  @override
  State createState() => _HandleEventViewState();
}

class _HandleEventViewState extends StateX<HandleEventView> {
  _HandleEventViewState() : super(HandleEventController()) {
    _controller = controller! as HandleEventController;
  }
  late HandleEventController _controller;
  late EventPopupController popupController;

  @override
  void initState() {
    super.initState();
    _controller.init(widget.date, widget.event);
    popupController = widget.popupController;
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: WaitingApi(
          child: Scaffold(
            appBar: appBar(
              context,
              _controller.title,
              backButton: true,
              icons: [
                Visibility(
                  visible: _controller.isUpdate,
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertPopup(
                          title: "Supprimer l'événement",
                          message:
                              "Voulez-vous vraiment supprimer cet événement ?",
                          confirmation: () async {
                            await _controller.deleteEvent();
                          },
                          popCurrentWidget: true,
                          popParameters: const {"action": "delete"},
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () async {
                    if (_controller.checkError()) return;
                    if (await (_controller.isUpdate
                        ? _controller.updateEvent()
                        : _controller.addEvent())) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, {
                        "action": _controller.isUpdate ? "update" : "add",
                        "event": _controller.event
                      });
                      return;
                    }
                  },
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _controller.titleController,
                    cursorColor: mainColor,
                    decoration: InputDecoration(
                      errorText: _controller.titleError,
                      hintText: "Titre",
                    ),
                    onChanged: (value) => _controller.updateTitle(value),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  _row(
                    icon: Icons.access_time_filled,
                    onTap: () => _controller.updateAllDay(),
                    children: [
                      const Text("Toute la journée"),
                      const Spacer(),
                      Switch(
                        activeColor: mainColor,
                        value: _controller.allDay,
                        onChanged: (_) => _controller.updateAllDay(),
                      )
                    ],
                  ),
                  _row(
                    icon: Icons.event,
                    onTap: () async {
                      final newStartDate =
                          await _selectDate(_controller.startDate);
                      if (newStartDate != null) {
                        _controller.startDate = newStartDate;
                      }
                    },
                    children: [
                      Text(_controller.startDateFormatted),
                      const Spacer(),
                      Visibility(
                        visible: !_controller.allDay,
                        child: Text(_controller.startTimeFormatted),
                      )
                    ],
                  ),
                  _row(
                    icon: Icons.event_busy,
                    onTap: () async {
                      final newEndDate = await _selectDate(_controller.endDate);
                      if (newEndDate != null) {
                        _controller.endDate = newEndDate;
                      }
                    },
                    children: [
                      Text(_controller.endDateFormatted),
                      const Spacer(),
                      Visibility(
                        visible: !_controller.allDay,
                        child: Text(_controller.endTimeFormatted),
                      )
                    ],
                  ),
                  _row(
                    icon: Icons.people_alt,
                    onTap: () async => {await _userPopup()},
                    children: _userAvatars(_controller.assignedUsers),
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async => false,
      );

  Future<DateTime?> _selectDate(DateTime initialDate) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: popupController.calendarController.firstDate,
      lastDate: popupController.calendarController.lastDate,
      builder: (context, child) => Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(
            primary: mainColor, // Couleur primaire
          ),
        ),
        child: child!,
      ),
    );

    if (newDate == null) return null;

    if (_controller.allDay) return newDate;

    // ignore: use_build_context_synchronously
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (context, child) => Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(
            primary: mainColor,
          ),
        ),
        child: child!,
      ),
    );

    if (newTime == null) return null;
    return DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      newTime.hour,
      newTime.minute,
    );
  }

  _row({
    required IconData icon,
    required List<Widget> children,
    required void Function() onTap,
  }) =>
      SizedBox(
        height: 50,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(icon, color: mainColor),
              const SizedBox(
                width: 20,
              ),
              ...children
            ],
          ),
        ),
      );

  Widget _userAvatar(String name, MaterialColor? color) => CircleAvatar(
        backgroundColor: color,
        radius: 15,
        child: Text(
          name.substring(0, 1),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

  List<Widget> _userAvatars(List<String> assignedUsers) {
    final result = <Widget>[];
    for (final username in assignedUsers) {
      result.add(
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: _userAvatar(username, users[username]!["color"]),
        ),
      );
    }
    return result;
  }

  Future<void> _userPopup() async {
    final userRows = <Widget>[];
    users.forEach((name, info) {
      userRows.add(
        Row(
          children: [
            _userAvatar(name, info["color"]),
            Text(name),
            const Spacer(),
            Checkbox(
              value: _controller.assignedUsers.contains(name),
              onChanged: (_) =>
                  setState(() => _controller.updateAssignedUsers(name)),
            )
          ],
        ),
      );
    });

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Utilisateurs assignés"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: users.entries
                .map(
                  (user) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        _userAvatar(user.key, user.value["color"]),
                        centerText(user.key),
                        const Spacer(),
                        Checkbox(
                          activeColor: mainColor,
                          value: _controller.assignedUsers.contains(user.key),
                          onChanged: (_) => setState(
                            () => _controller.updateAssignedUsers(user.key),
                          ),
                        )
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
