import 'package:flutter/material.dart';
import 'package:utils_app/constants.dart';

class PlusButton extends StatelessWidget {
  const PlusButton({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        mini: true,
        onPressed: onPressed,
        foregroundColor: textColor,
        child: const Icon(Icons.add),
      );
}

class MinusButton extends StatelessWidget {
  const MinusButton({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        mini: true,
        onPressed: onPressed,
        foregroundColor: textColor,
        child: const Icon(Icons.remove),
      );
}
