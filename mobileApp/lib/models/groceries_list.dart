import 'package:state_notifier/state_notifier.dart';
import 'package:mathiflo/data/data.dart';
import 'package:mathiflo/data/item.dart';

class GroceriesListNotifier extends StateNotifier<List<Item>> {
  GroceriesListNotifier() : super(groceriesBox.values.toList().cast<Item>());

  bool get isEmpty => state.isEmpty;

  void addItem(Item item) {
    state = [...state, item];
    _sort();
  }

  void clear() {
    state = [];
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

  void _sort() {
    state.sort((a, b) => a.name.compareTo(b.name));
  }
}
