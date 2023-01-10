import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';

// Public

plusButton(void Function()? onPressed) =>
    _floatingButton(const Icon(Icons.add), onPressed);

minusButton(void Function()? onPressed) =>
    _floatingButton(const Icon(Icons.remove), onPressed);

// Private

_floatingButton(Icon icon, void Function()? onPressed) => FloatingActionButton(
      mini: true,
      onPressed: onPressed,
      foregroundColor: textColor,
      child: icon,
    );
