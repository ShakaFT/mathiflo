import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';

AppBar appBar(
  BuildContext context,
  String title, {
  List<Widget> icons = const [],
  bool backButton = false,
}) =>
    AppBar(
      title: Text(title, style: const TextStyle(color: textColor)),
      leading: backButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
      backgroundColor: mainColor,
      iconTheme: const IconThemeData(color: textColor),
      actions: icons,
    );

BottomAppBar bottomBar({required Widget child}) =>
    BottomAppBar(color: mainColor, child: child);

class ButtonBarButton extends StatelessWidget {
  const ButtonBarButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(textColor),
        ),
        onPressed: onPressed,
        child: Text(text),
      );
}
