import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';

// Public

button(String title, void Function()? onPressed) => ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(mainColor),
      ),
      child: Text(title, style: TextStyle(color: textColor)),
    );

plusButton(void Function()? onPressed) =>
    _floatingButton(const Icon(Icons.add), onPressed);

minusButton(void Function()? onPressed) =>
    _floatingButton(const Icon(Icons.remove), onPressed);

// Private

_floatingButton(Icon icon, void Function()? onPressed) => FloatingActionButton(
      mini: true,
      onPressed: onPressed,
      backgroundColor: mainColor,
      foregroundColor: textColor,
      child: icon,
    );
