import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';

centerText(String text, {double padding = 8.0, TextStyle? style}) => Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Text(
          text,
          style: style,
        ),
      ),
    );

errorText(String message) => Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        message,
        style: TextStyle(
          color: errorColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

scrollableText(String text, {double padding = 8.0, TextStyle? style}) => Stack(
      children: [
        centerText(text, padding: padding, style: style),
        ListView(
          physics: const AlwaysScrollableScrollPhysics(),
        )
      ],
    );
