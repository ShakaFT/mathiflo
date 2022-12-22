import 'package:flutter/material.dart';
import 'package:utils_app/constants.dart';

class AppBarButton extends StatelessWidget {
  const AppBarButton({super.key, required this.text, required this.onPressed});

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
