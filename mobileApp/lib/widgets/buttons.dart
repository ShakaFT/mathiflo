import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';

// Public

button(String title, void Function()? onPressed, {bool disabled = false}) =>
    ElevatedButton(
      onPressed: disabled ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: disabled
            ? MaterialStateProperty.all<Color>(Colors.grey)
            : MaterialStateProperty.all<Color>(mainColor),
      ),
      child: Text(title, style: TextStyle(color: textColor)),
    );

plusButton(void Function()? onPressed, {bool disabled = false}) =>
    _floatingButton(
      const Icon(Icons.add),
      onPressed,
      disabled: disabled,
    );

minusButton(void Function()? onPressed, {bool disabled = false}) =>
    _floatingButton(
      const Icon(Icons.remove),
      onPressed,
      disabled: disabled,
    );

nextButton(void Function()? onPressed, {bool disabled = false}) =>
    _floatingButton(
      const Icon(Icons.arrow_right),
      onPressed,
      disabled: disabled,
    );

previousButton(void Function()? onPressed, {bool disabled = false}) =>
    _floatingButton(
      const Icon(Icons.arrow_left),
      onPressed,
      disabled: disabled,
    );

// Private

_floatingButton(
  Icon icon,
  void Function()? onPressed, {
  bool disabled = false,
}) =>
    FloatingActionButton(
      mini: true,
      onPressed: disabled ? null : onPressed,
      backgroundColor: disabled ? Colors.grey : mainColor,
      foregroundColor: textColor,
      heroTag: Random().nextInt(
        1000000000,
      ), // fix error when we use multiple floating buttons
      child: icon,
    );
