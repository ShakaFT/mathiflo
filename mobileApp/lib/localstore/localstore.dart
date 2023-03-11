import 'package:localstore/localstore.dart';

final _db = Localstore.instance;

Future<List<String>> getCheckedItems() async {
  final items = await _db.collection("groceries").doc("items").get() ?? {};
  return List<String>.from(items["checked"] ?? []);
}

Future<void> addCheckedItem(String itemName) async {
  final currentCheckedItems = await getCheckedItems();
  currentCheckedItems.add(itemName);
  await _db
      .collection("groceries")
      .doc("items")
      .set({"checked": currentCheckedItems});
}

Future<void> removeCheckedItem(String itemName) async {
  final currentCheckedItems = await getCheckedItems();
  currentCheckedItems.removeWhere((name) => name == itemName);
  await _db
      .collection("groceries")
      .doc("items")
      .set({"checked": currentCheckedItems});
}
