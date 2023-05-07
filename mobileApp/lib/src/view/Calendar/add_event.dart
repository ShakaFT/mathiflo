import 'package:flutter/material.dart';
import 'package:mathiflo/src/controller/Calendar/event_popup_controller.dart';
import 'package:mathiflo/src/model/Calendar/calendar_event.dart';
import 'package:mathiflo/src/widgets/bar.dart';
import 'package:state_extended/state_extended.dart';

class AddEventView extends StatefulWidget {
  const AddEventView({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  State createState() => _AddEventViewState();
}

class _AddEventViewState extends StateX<AddEventView> {
  _AddEventViewState() : super(EventPopupController());

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar(
          "Ajouter un événement",
          icons: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Navigator.of(context).pop(
                  Event(
                    "Événement",
                    widget.date.millisecondsSinceEpoch,
                    widget.date.millisecondsSinceEpoch,
                  ),
                );
              },
            )
          ],
        ),
        body: const Center(
          child: Text(
            'Contenu de la nouvelle page',
          ),
        ),
      );
}
