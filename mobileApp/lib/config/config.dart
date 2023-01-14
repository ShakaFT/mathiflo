import 'dart:convert';

import 'package:flutter/services.dart';

late String defaultUrl;
late String groceriesUrl;

Future<void> loadConfigData() async {
  // Load config data
  final configString = await rootBundle.loadString('assets/config/config.json');
  final dynamic data = jsonDecode(configString);

  // Set data
  defaultUrl = data['restAPI']['default'];
  groceriesUrl = data['restAPI']['groceries'];
}
