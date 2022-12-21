import 'package:flutter/material.dart';
import 'package:utils_app/constants.dart';

// ignore_for_file: must_be_immutable
class ConfirmationPopup extends StatelessWidget {
  const ConfirmationPopup({
    super.key,
    required this.title,
    required this.text,
    required this.confirmation,
  });

  final String title;
  final String text;
  final void Function() confirmation;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(title, style: TextStyle(color: popupColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(text),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      confirmation();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context); // close popup
                    },
                    child: Text("Annuler", style: TextStyle(color: textColor)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      confirmation();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context); // close popup
                    },
                    child:
                        Text("Confirmer", style: TextStyle(color: textColor)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
