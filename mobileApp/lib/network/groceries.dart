import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathiflo/config/config.dart' as config;
import 'package:mathiflo/models/groceries_item.dart';

Future<List<Item>?> getNetworkGroceries() async {
  // If returns null, API call has not worked
  final uri = Uri.tryParse(
    '${config.groceriesUrl}/groceries',
  )!;

  try {
    final response = await http.get(uri);

    if (response.statusCode < 200 || response.statusCode > 299) {
      return null;
    }
    final decodedPayload = json.decode(response.body)["groceriesList"];

    final groceriesList = <Item>[];
    for (final element in decodedPayload) {
      groceriesList.add(Item(element["name"], element["quantity"]));
    }
    return groceriesList;
  } catch (e) {
    return null;
  }
}

Future<bool> updateNetworkGroceries(List<Item> groceriesList) async {
  final uri = Uri.tryParse(
    '${config.groceriesUrl}/groceries/update',
  )!;

  final payload = [];
  for (final item in groceriesList) {
    payload.add({"name": item.name, "quantity": item.quantity});
  }
  final encodedPayload = jsonEncode({'groceriesList': payload});
  try {
    final response = await http.post(uri, body: encodedPayload);
    return response.statusCode >= 200 && response.statusCode <= 299;
  } catch (e) {
    return false;
  }
}

Future<bool> resetNetworkGroceries() async {
  final uri = Uri.tryParse(
    '${config.groceriesUrl}/groceries/reset',
  )!;

  try {
    final response = await http.post(uri);
    return response.statusCode >= 200 && response.statusCode <= 299;
  } catch (e) {
    return false;
  }
}
