import 'package:mathiflo/localstore/localstore.dart';
import 'package:mathiflo/models/groceries_item.dart';
import 'package:mathiflo/network/groceries.dart';
import 'package:state_notifier/state_notifier.dart';

class GroceriesListNotifier extends StateNotifier<List<Item>> {
  GroceriesListNotifier() : super([]);

  // Public methods

  void addItem(Item item) {
    state = [...state, item];
    _sort();
  }

  void clear() {
    state = [];
  }

  bool exists(String name) => state.any((item) => item.name == name);

  bool get isEmpty => state.isEmpty;

  List<Item> get items => state;

  Future<bool> refresh() async {
    final groceriesList = await getNetworkGroceries();
    if (groceriesList is List<Item>) {
      state = groceriesList;
      _sort();

      final checkedItems = await getCheckedItems();
      for (var item in groceriesList) {
        item.checked = checkedItems.contains(item.name);
      }

      return true;
    }
    return false;
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

  void replaceItem(int index, Item item) {
    state.removeAt(index);
    state = [...state, item];
    _sort();
  }

  void removeItem(int index) {
    state.removeAt(index);
    notify();
  }

  // Private methods

  void _sort() {
    state.sort((a, b) => a.name.compareTo(b.name));
  }
}
