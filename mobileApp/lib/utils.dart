import 'package:flutter/material.dart';

Future<void> navigation(BuildContext context, Widget view) async {
  await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => view),
  );
}

loading(Future<void> Function() awaitedFunction, widgetToDisplay) =>
    FutureBuilder(
      // ignore: discarded_futures
      future: awaitedFunction(),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : widgetToDisplay,
    );
