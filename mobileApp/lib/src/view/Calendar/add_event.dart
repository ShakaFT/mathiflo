import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/controller/Calendar/add_event_controller.dart';
import 'package:mathiflo/src/controller/Calendar/event_popup_controller.dart';
import 'package:mathiflo/src/widgets/bar.dart';
import 'package:mathiflo/src/widgets/texts.dart';
import 'package:state_extended/state_extended.dart';

class AddEventView extends StatefulWidget {
  const AddEventView({
    super.key,
    required this.popupController,
    required this.date,
  });

  final DateTime date;
  final EventPopupController popupController;

  @override
  State createState() => _AddEventViewState();
}

class _AddEventViewState extends StateX<AddEventView> {
  _AddEventViewState() : super(AddEventController()) {
    _controller = controller! as AddEventController;
  }
  late AddEventController _controller;
  late EventPopupController popupController;

  @override
  void initState() {
    super.initState();
    _controller.init(widget.date);
    popupController = widget.popupController;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar(
          "Ajouter un événement",
          icons: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                if (!_controller.checkError()) {
                  Navigator.of(context).pop(_controller.newEvent);
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
                decoration: InputDecoration(
                  errorText: _controller.titleError,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainColor),
                  ),
                  hintText: "Titre",
                ),
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
                  final newStartDate = await _selectDate(_controller.startDate);
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
            primary: mainColor, // Couleur primaire
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

  List<Widget> _userAvatars(Map<String, Map<String, dynamic>> users) {
    final result = <Widget>[];
    users.forEach((name, info) {
      result.add(
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: _userAvatar(name, info["color"]),
        ),
      );
    });
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
              value: _controller.assignedUsers.containsKey(name),
              onChanged: (_) =>
                  setState(() => _controller.updateAssignedUsers(name, info)),
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
                          value:
                              _controller.assignedUsers.containsKey(user.key),
                          onChanged: (_) => setState(
                            () => _controller.updateAssignedUsers(
                              user.key,
                              user.value,
                            ),
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
