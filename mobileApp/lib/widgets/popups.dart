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
  final void Function()? confirmation;

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
                _actionButton(context, "Annuler", () {}),
                _actionButton(context, "Confirmer", confirmation),
              ],
            ),
          ],
        ),
      );

  // Private methods

  _actionButton(BuildContext context, String title, void Function()? action) =>
      Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ElevatedButton(
          onPressed: action == null
              ? null
              : () {
                  action();
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context); // close popup
                },
          child: Text(title, style: TextStyle(color: textColor)),
        ),
      );
}

snackbar(BuildContext context, String text, {bool error = false}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: error ? Colors.red : Colors.blue,
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height / 2.5,
          right: 20,
          left: 20,
        ),
      ),
    );
