import 'package:diacritic/diacritic.dart';
import 'package:mathiflo/src/localstore/groceries.dart';
import 'package:mathiflo/src/model/Groceries/groceries_item.dart';
import 'package:mathiflo/src/model/Groceries/groceries_network.dart';
import 'package:state_notifier/state_notifier.dart';

class GroceriesListNotifier extends StateNotifier<List<Item>> {
  GroceriesListNotifier() : super([]);

  // Getters

  bool get isEmpty => state.isEmpty;
  List<Item> get items => state;

  // Public methods

  void addItem(Item item) {
    state.add(item);
    _sort();
  }

  bool exists(String name) => state.any((item) => item.name == name);

  Future<bool> refresh() async {
    final groceriesList = await getNetworkGroceries();
    if (groceriesList is! List<Item>) {
      return false;
    }

    // Retrieve all checked items
    final itemIds = <String>[];
    final checkedItems = await getCheckedItems();

    for (final item in groceriesList) {
      item.checked = checkedItems.contains(item.id);
      itemIds.add(item.id);
    }

    // Remove all checked items that are no longer in database.
    for (final checkedId in checkedItems) {
      if (!itemIds.contains(checkedId)) {
        await removeCheckedItem(checkedId);
      }
    }

    state = groceriesList;
    _sort();

    return true;
  }

  set items(List<Item> newItems) {
    state = newItems;
  }

  void updateCheck(int index, {bool checked = true}) {
    state[index].checked = checked;
    notify();
  }

  void notify() {
    state = [...state];
  }

  Future<void> replaceItem(int index, Item item) async {
    final removedItem = state.removeAt(index);
    if (removedItem.checked) {
      await removeCheckedItem(removedItem.id);
      await addCheckedItem(item.name);
      item.checked = true;
    }
    state.add(item);
    _sort();
  }

  Future<void> removeItem(int index) async {
    final removedItem = state.removeAt(index);
    await removeCheckedItem(removedItem.id);
    notify();
  }

  // Private methods

  void _sort() {
    state.sort(
      (a, b) => removeDiacritics(a.name).compareTo(removeDiacritics(b.name)),
    );
    notify();
  }
}
