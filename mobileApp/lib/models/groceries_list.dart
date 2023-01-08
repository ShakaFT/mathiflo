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

  Future<bool> refresh() async {
    final groceriesList = await getNetworkGroceries();
    if (groceriesList is List<Item>) {
      state = groceriesList;
      return true;
    }
    return false;
  }

  set items(List<Item> newItems) {
    state = newItems;
  }

  void replaceItem(int index, Item item) {
    state.removeAt(index);
    state = [...state, item];
    _sort();
  }

  void removeItem(int index) {
    state.removeAt(index);
    state = [...state];
  }

  // Private methods

  void _sort() {
    state.sort((a, b) => a.name.compareTo(b.name));
  }
}
