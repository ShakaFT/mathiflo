import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';

appBar(String title, {List<Widget> icons = const []}) => AppBar(
      title: Text(title, style: TextStyle(color: textColor)),
      backgroundColor: mainColor,
      iconTheme: IconThemeData(color: textColor),
      actions: icons,
    );

bottomBar({required Widget child}) =>
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
