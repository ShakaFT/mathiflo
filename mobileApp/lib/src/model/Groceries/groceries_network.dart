
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathiflo/config.dart' as config;
import 'package:mathiflo/src/model/Groceries/groceries_item.dart';

Future<List<Item>?> getNetworkGroceries() async {
  // If returns null, API call has not worked
  final uri = Uri.tryParse(
    '${config.groceriesRestApiUrl}/groceries?debug=true',
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
    '${config.groceriesRestApiUrl}/groceries',
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

Future<bool> resetNetworkGroceries(
  List<String> toDelete, {
  all = false,
}) async {
  final uri = Uri.tryParse(
    '${config.groceriesRestApiUrl}/groceries',
  )!;

  final encodedPayload = jsonEncode({'all': all, 'toDelete': toDelete});
  try {
    final response = await http.delete(uri, body: encodedPayload);
    return response.statusCode >= 200 && response.statusCode <= 299;
  } catch (e) {
    return false;
  }
}
