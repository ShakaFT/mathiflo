import 'package:flutter/material.dart';

centerText(String text, {double padding = 8.0, TextStyle? style}) => Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Text(
          text,
          style: style,
        ),
      ),
    );
