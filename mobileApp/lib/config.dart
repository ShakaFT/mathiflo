import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstore/localstore.dart';

// Instance of local database
final localDatabase = Localstore.instance;

// Variable allowing to be notified when the application
// is waiting for a response from the restAPI
final ValueNotifier pendingAPI = ValueNotifier(false);

// Url to call rest API
late String defaultRestApiUrl;
late String cuddlyToysRestApiUrl;
late String groceriesRestApiUrl;

Future<void> loadConfigData() async {
  // Load environment variables
  await dotenv.load();

  // Load config data
  final configString = await rootBundle.loadString('assets/config/config.json');
  final dynamic data = jsonDecode(configString);

  // Set data
  defaultRestApiUrl = data['restAPI']['default'];
  cuddlyToysRestApiUrl = data['restAPI']['cuddlyToys'];
  groceriesRestApiUrl = data['restAPI']['groceries'];
}
