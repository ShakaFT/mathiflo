import 'package:flutter/material.dart';

void navigation(BuildContext context, Widget view) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => view),
  );
}
