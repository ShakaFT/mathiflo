import 'package:state_notifier/state_notifier.dart';
import 'package:utils_app/data/data.dart';
import 'package:utils_app/data/item.dart';

class GroceriesListNotifier extends StateNotifier<List<Item>> {
  GroceriesListNotifier() : super(groceriesBox.values.toList().cast<Item>());

  void addItem(Item item) {
    state = [...state, item];
    _sort();
  }

  void _sort() {
    state.sort((a, b) => a.name.compareTo(b.name));
  }
}
