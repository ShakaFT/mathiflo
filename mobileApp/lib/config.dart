import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:localstore/localstore.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Instance of local database
final localDatabase = Localstore.instance;

// Variable allowing to be notified when the application
// is waiting for a response from the restAPI
final ValueNotifier pendingAPI = ValueNotifier(false);

const apiKeyHeader = String.fromEnvironment("MATHIFLO_API_KEY_HEADER");
const apiKey = String.fromEnvironment("MATHIFLO_API_KEY");

// Url to call rest API
late String defaultRestApiUrl;
late String cuddlyToysRestApiUrl;
late String groceriesRestApiUrl;
late PackageInfo packageInfo;

Future<void> loadConfigData() async {
  // Load config data
  final configString = await rootBundle.loadString('assets/config/config.json');
  final dynamic data = jsonDecode(configString);

  // Set data
  defaultRestApiUrl = data['restAPI']['default'];
  cuddlyToysRestApiUrl = data['restAPI']['cuddlyToys'];
  groceriesRestApiUrl = data['restAPI']['groceries'];

  // Set mobile app info
  packageInfo = await PackageInfo.fromPlatform();
}
