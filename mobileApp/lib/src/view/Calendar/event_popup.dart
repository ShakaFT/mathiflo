import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/controller/Calendar/calendar_controller.dart';
import 'package:mathiflo/src/controller/Calendar/event_popup_controller.dart';
import 'package:mathiflo/src/model/Calendar/calendar_event.dart';
import 'package:mathiflo/src/view/Calendar/handle_event.dart';
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
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HandleEventView(
                      popupController: popupController,
                      date: popupController.date,
                    ),
                  ),
                );
                if (result == null) return;
                if (result["action"] == "add") {
                  popupController.addEvent(result["event"]);
                }
              })
            ],
          ),
          content: popupController.events.isEmpty
              ? centerText("Aucun événement")
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: popupController.events.length,
                    itemBuilder: (context, index) => IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: InkWell(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HandleEventView(
                                  popupController: popupController,
                                  date: popupController.date,
                                  event: popupController.events[index],
                                ),
                              ),
                            );
                            if (result == null) return;
                            if (result["action"] == "update") {
                              popupController.updateEvent(
                                popupController.events[index],
                                result["event"],
                              );
                            } else if (result["action"] == "delete") {
                              popupController
                                  .removeEvent(popupController.events[index]);
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 30,
                                child: Text(
                                  popupController.events[index]
                                      .timeToDisplay(popupController.date),
                                  maxLines: 2,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                              VerticalDivider(
                                thickness: 2,
                                color: mainColor,
                              ),
                              Expanded(
                                child: Text(
                                  popupController.events[index].title,
                                  maxLines: 2,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              ..._userAvatars(popupController.events[index])
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      );

  List<Widget> _userAvatars(Event event) {
    final result = <Widget>[];
    for (var _ = 0; _ < users.length - event.users.length; _++) {
      result.add(_avatar("", {"color": Colors.white}));
    }
    event.users.forEach((name, info) {
      result.add(_avatar(name, info));
    });
    return result;
  }

  _avatar(String name, Map<String, dynamic> info) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: CircleAvatar(
          backgroundColor: info["color"],
          radius: 15,
          child: Text(
            name.isEmpty ? "" : name.substring(0, 1),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
}
