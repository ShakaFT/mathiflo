import 'package:flutter/material.dart';

Future<void> navigation(BuildContext context, Widget view) async {
  await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => view),
  );
}
