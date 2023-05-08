import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/controller/Calendar/calendar_controller.dart';
import 'package:mathiflo/src/controller/Calendar/event_popup_controller.dart';
import 'package:mathiflo/src/view/Calendar/add_event.dart';
import 'package:mathiflo/src/widgets/buttons.dart';
import 'package:mathiflo/src/widgets/texts.dart';
import 'package:state_extended/state_extended.dart';

class EventPopup extends StatefulWidget {
  const EventPopup({
    super.key,
    required this.calendarController,
    required this.date,
  });

  final CalendarController calendarController;
  final DateTime date;

  @override
  State createState() => _EventPopupState();
}

class _EventPopupState extends StateX<EventPopup> {
  _EventPopupState() : super(EventPopupController()) {
    popupController = controller! as EventPopupController;
  }
  late EventPopupController popupController;

  @override
  void initState() {
    super.initState();
    popupController
      ..calendarController = widget.calendarController
      ..date = widget.date
      ..events = popupController.calendarController.matchEvents(widget.date);
  }

  @override
  Widget build(BuildContext context) => StatefulBuilder(
        builder: (context, setPopupState) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE d MMMM', 'fr_FR').format(popupController.date),
                style: TextStyle(color: popupColor),
              ),
              plusButton(() async {
                final newEvent = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEventView(
                      popupController: popupController,
                      date: popupController.date,
                    ),
                  ),
                );
                if (newEvent != null) {
                  popupController.calendarController.addEvent(newEvent);
                  setState(() {
                    popupController.events.add(newEvent);
                  });
                }
              })
            ],
          ),
          content: popupController.events.isEmpty
              ? centerText("Aucun événement")
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[Text("ok")],
                ),
        ),
      );
}
