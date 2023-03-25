import 'package:flutter/material.dart';

scrollableText(String text, {double padding = 8.0, TextStyle? style}) => Stack(
      children: [
        centerText(text, padding: padding, style: style),
        ListView(
          physics: const AlwaysScrollableScrollPhysics(),
        )
      ],
    );

centerText(String text, {double padding = 8.0, TextStyle? style}) => Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Text(
          text,
          style: style,
        ),
      ),
    );
