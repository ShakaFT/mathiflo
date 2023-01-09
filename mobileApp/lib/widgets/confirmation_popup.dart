import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';

// ignore_for_file: must_be_immutable
class ConfirmationPopup extends StatelessWidget {
  const ConfirmationPopup({
    super.key,
    required this.title,
    required this.message,
    required this.confirmation,
  });

  final String title;
  final String message;
  final void Function() confirmation;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(title, style: TextStyle(color: popupColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(message),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _actionButton(context, "Annuler"),
                _actionButton(context, "Confirmer"),
              ],
            ),
          ],
        ),
      );

  // Private methods

  _actionButton(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ElevatedButton(
          onPressed: () {
            confirmation();
            // ignore: use_build_context_synchronously
            Navigator.pop(context); // close popup
          },
          child: Text(title, style: TextStyle(color: textColor)),
        ),
      );
}
