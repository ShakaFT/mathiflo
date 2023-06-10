// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mathiflo/config.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/widgets/buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class AlertPopup extends StatelessWidget {
  const AlertPopup({
    super.key,
    required this.title,
    required this.message,
    required this.confirmation,
    this.popCurrentWidget = false,
    this.popParameters,
  });

  final String title;
  final String message;
  final Future<void> Function()? confirmation;
  final bool popCurrentWidget;
  final dynamic popParameters;

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => !pendingAPI.value,
        child: AlertDialog(
          title: Text(title, style: TextStyle(color: popupColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(message),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _actionButton(context, "Annuler"),
                  _actionButton(context, "Confirmer", action: confirmation),
                ],
              ),
            ],
          ),
        ),
      );

  // Private methods

  _actionButton(
    BuildContext context,
    String title, {
    Future<void> Function()? action,
  }) =>
      Padding(
        padding: const EdgeInsets.only(top: 20),
        child: button(
          title,
          action == null
              ? () {
                  if (pendingAPI.value) {
                    return;
                  }
                  Navigator.pop(context);
                } // close popup
              : () async {
                  if (pendingAPI.value) {
                    return;
                  }
                  await action();
                  try {
                    Navigator.pop(context); // close popup
                  } finally {
                    if (popCurrentWidget) {
                      // close current widget
                      Navigator.pop(context, popParameters);
                    }
                  }
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

avatarImage(BuildContext context, ImageProvider image) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 20,
        backgroundImage: image,
        child: GestureDetector(
          onTap: () async {
            await showDialog(
              context: context,
              builder: (_) => Dialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

needUpdateAppPopup({
  required String bundleId,
  bool display = true,
  Widget? child,
}) =>
    display
        ? Stack(
            children: [
              IgnorePointer(
                child: child,
              ),
              Positioned.fill(
                child: Align(
                  child: AlertDialog(
                    title: const Text("Une mise à jour est disponible"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          "Une mise à jour est disponible, veuillez effectuer la mise à jour pour continuer...",
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: button("Mise à jour", () async {
                            await launchUrl(
                              Uri.parse("market://details?id=com.mathiflo"),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        : child;
