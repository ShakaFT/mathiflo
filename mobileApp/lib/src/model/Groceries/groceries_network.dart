import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathiflo/config.dart' as config;
import 'package:mathiflo/constants.dart';
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
    final groceriesList = <Item>[];
    for (final item in json.decode(response.body)["groceriesList"]) {
      groceriesList.add(Item.fromMap(item));
    }
    return groceriesList;
  } catch (e) {
    return null;
  }
}

Future<String> addNetworkGroceriesItem(Item item) async {
  final uri = Uri.tryParse(
    '${config.groceriesRestApiUrl}/groceries/${item.id}',
  )!;

  final encodedPayload = jsonEncode(item.toMap());
  try {
    final response = await http.post(uri, body: encodedPayload);
    if (response.statusCode <= 200 && response.statusCode >= 299) {
      return unknownError;
    }

    if (json.decode(response.body)["exists"]) {
      return "Cet article existe déjà, mets à jour ta liste de courses.";
    }

    return "";
  } catch (e) {
    return unknownError;
  }
}

Future<String> updateNetworkGroceriesItem(Item item) async {
  final uri = Uri.tryParse(
    '${config.groceriesRestApiUrl}/groceries/${item.id}',
  )!;

  final encodedPayload = jsonEncode(item.toMap());
  try {
    final response = await http.put(uri, body: encodedPayload);
    if (response.statusCode <= 200 && response.statusCode >= 299) {
      return unknownError;
    }

    if (!json.decode(response.body)["exists"]) {
      return "Cet article n'existe plus, mets à jour ta liste de courses.";
    }

    return "";
  } catch (e) {
    return unknownError;
  }
}

Future<bool> deleteNetworkGroceriesItems(
  List<String> toDelete, {
  all = false,
}) async {
  final uri = Uri.tryParse(
    '${config.groceriesRestApiUrl}/groceries',
  )!;

  final encodedPayload = jsonEncode({'all': all, 'groceriesItems': toDelete});
  try {
    final response = await http.delete(uri, body: encodedPayload);
    return response.statusCode >= 200 && response.statusCode <= 299;
  } catch (e) {
    return false;
  }
}
