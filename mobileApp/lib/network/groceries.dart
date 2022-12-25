import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/data/data.dart';
import 'package:mathiflo/data/item.dart';

Future<bool> loadGroceries() async {
  final url = Uri.tryParse(
    '$urlGroceries/groceries',
  );
  final response = await http.get(url!);

  if (response.statusCode < 200 && response.statusCode > 299) {
    return false;
  }

  final Map<String, dynamic> decodedPayload = json.decode(response.body);
  await groceriesBox.clear();

  decodedPayload.forEach(
    (name, info) => {
      groceriesBox.put(
        name,
        Item(
          name: name,
          quantity: info["quantity"],
          lastUpdate: info["lastUpdate"],
        ),
      )
    },
  );
  return true;
}

Future<bool> updateGroceries(List<Item> items) async {
  final url = Uri.tryParse(
    '$urlGroceries/groceries/update',
  );

  final newItems = <String, dynamic>{};
  for (final item in items) {
    newItems[item.name] = {
      "quantity": item.quantity,
      "lastUpdate": item.lastUpdate,
    };
  }
  final payload = jsonEncode({'newItems': newItems});
  final response = await http.post(url!, body: payload);

  return response.statusCode < 200 && response.statusCode > 299;
}

Future<bool> resetGroceries() async {
  final url = Uri.tryParse(
    '$urlGroceries/groceries/reset',
  );
  final response = await http.post(url!);
  return response.statusCode < 200 && response.statusCode > 299;
}
