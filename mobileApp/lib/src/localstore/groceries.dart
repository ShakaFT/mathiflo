import 'package:mathiflo/config.dart';

Future<List<String>> getCheckedItems() async {
  final items =
      await localDatabase.collection("groceries").doc("items").get() ?? {};
  return List<String>.from(items["checked"] ?? []);
}

Future<void> addCheckedItem(String itemName) async {
  final currentCheckedItems = await getCheckedItems();
  currentCheckedItems.add(itemName);
  await localDatabase
      .collection("groceries")
      .doc("items")
      .set({"checked": currentCheckedItems});
}

Future<void> removeCheckedItem(String itemName) async {
  final currentCheckedItems = await getCheckedItems();
  currentCheckedItems.removeWhere((name) => name == itemName);
  await localDatabase
      .collection("groceries")
      .doc("items")
      .set({"checked": currentCheckedItems});
}
