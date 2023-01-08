import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathiflo/constants.dart';

import 'package:mathiflo/models/groceries_item.dart';

Future<List<Item>?> getNetworkGroceries() async {
  // If returns null, API call has not worked
  final uri = Uri.tryParse(
    '$urlGroceries/groceries',
  )!;
  final response = await http.get(uri);

  if (response.statusCode < 200 && response.statusCode > 299) {
    return null;
  }

  final Map<String, dynamic> decodedPayload = json.decode(response.body);
  return decodedPayload["groceriesList"];
}

Future<bool> updateNetworkGroceries(List<Item> groceriesList) async {
  final uri = Uri.tryParse(
    '$urlGroceries/groceries/update',
  )!;

  final payload = jsonEncode({'groceriesList': groceriesList});
  final response = await http.post(uri, body: payload);

  return response.statusCode < 200 && response.statusCode > 299;
}

Future<bool> resetNetworkGroceries() async {
  final uri = Uri.tryParse(
    '$urlGroceries/groceries/reset',
  )!;
  final response = await http.post(uri);
  return response.statusCode < 200 && response.statusCode > 299;
}
