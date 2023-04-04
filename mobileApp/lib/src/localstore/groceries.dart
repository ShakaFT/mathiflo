import 'package:mathiflo/config.dart';

Future<List<String>> getCheckedItems() async {
  final items =
      await localDatabase.collection("groceries").doc("items").get() ?? {};
  return List<String>.from(items["checked"] ?? []);
}

Future<void> addCheckedItem(String itemId) async {
  final currentCheckedItems = await getCheckedItems();
  currentCheckedItems.add(itemId);
  await localDatabase
      .collection("groceries")
      .doc("items")
      .set({"checked": currentCheckedItems});
}

Future<void> removeCheckedItem(String itemId) async {
  final currentCheckedItems = await getCheckedItems();
  currentCheckedItems.removeWhere((name) => name == itemId);
  await localDatabase
      .collection("groceries")
      .doc("items")
      .set({"checked": currentCheckedItems});
}
