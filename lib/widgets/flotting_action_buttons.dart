import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  const PlusButton({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        mini: true,
        onPressed: onPressed,
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
        child: const Icon(Icons.remove),
      );
}
