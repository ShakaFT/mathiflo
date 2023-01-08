import 'package:mathiflo/data/data.dart';
import 'package:mathiflo/data/item.dart';
import 'package:state_notifier/state_notifier.dart';

class GroceriesListNotifier extends StateNotifier<List<Item>> {
  GroceriesListNotifier() : super([]);

  // Public methods

  bool get isEmpty => state.isEmpty;

  void addItem(Item item) {
    state = [...state, item];
    _sort();
  }

  void clear() {
    state = [];
  }

  void fetchLocalDatabase() {
    state = groceriesBox.values.toList().cast<Item>();
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
