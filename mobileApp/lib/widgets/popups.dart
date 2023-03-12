import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/widgets/buttons.dart';

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
        child: button(
          title,
          action == null
              ? null
              : () {
                  action();
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context); // close popup
                },
        ),
      );
}

snackbar(BuildContext context, String text, {bool error = false}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: error ? errorColor : Colors.blue,
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

avatarImage(BuildContext context, String imageUrl) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(imageUrl),
        child: GestureDetector(
          onTap: () async {
            await showDialog(
              context: context,
              builder: (_) => Dialog(
                child: Image.network(imageUrl,
                    width: MediaQuery.of(context).size.width / 2),
              ),
            );
          },
        ),
      ),
    );
