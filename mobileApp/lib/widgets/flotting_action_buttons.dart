import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';

// Public

class PlusButton extends StatelessWidget {
  const PlusButton({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) =>
      _floatingButton(const Icon(Icons.add), onPressed);
}

class MinusButton extends StatelessWidget {
  const MinusButton({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) =>
      _floatingButton(const Icon(Icons.remove), onPressed);
}

// Private

_floatingButton(Icon icon, void Function() onPressed) => FloatingActionButton(
      mini: true,
      onPressed: onPressed,
      foregroundColor: textColor,
      child: const Icon(Icons.remove),
    );
