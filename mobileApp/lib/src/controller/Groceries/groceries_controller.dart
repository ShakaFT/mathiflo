import 'dart:async';

import 'package:mathiflo/config.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/localstore/groceries.dart';
import 'package:mathiflo/src/model/Groceries/groceries.dart';
import 'package:mathiflo/src/model/Groceries/groceries_item.dart';
import 'package:mathiflo/src/model/Groceries/groceries_list.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vibration/vibration.dart';

class GroceriesController extends ControllerMVC {
  factory GroceriesController([StateMVC? state]) =>
      _this ??= GroceriesController._(state);
  GroceriesController._(super.state) : _groceriesList = GroceriesListNotifier();
  static GroceriesController? _this;

  // Model
  final GroceriesListNotifier _groceriesList;

  // Streams
  StreamController<bool> addItemPopup = StreamController<bool>();
  StreamController<bool> clearListPopup = StreamController<bool>();

  // Methods

  GroceriesListNotifier get groceriesList => _groceriesList;

  bool groceriesContains(String name) => _groceriesList.exists(name);

  Future<String> addGroceriesItem(Item item, int index) async {
    pendingAPI.value = true;
    var error = "";
    final newGroceriesList = [..._groceriesList.items, item];
    if (await updateNetworkGroceries(newGroceriesList)) {
      _groceriesList.addItem(item);
    } else {
      error = unknownError;
    }
    pendingAPI.value = false;
    return error;
  }

  Future<String> updateGroceriesItem(Item item, int index) async {
    pendingAPI.value = true;
    var error = "";
    final newGroceriesList = [..._groceriesList.items, item]..removeAt(index);
    if (await updateNetworkGroceries(newGroceriesList)) {
      await _groceriesList.replaceItem(index, item);
    } else {
      error = unknownError;
    }
    pendingAPI.value = false;
    return error;
  }

  Future<void> checkItem(
    String name,
    int index, {
    required bool checked,
  }) async {
    final checkedItems = await getCheckedItems();

    if (checkedItems.contains(name) && checked) {
      await removeCheckedItem(name);
    } else if (!checkedItems.contains(name) && !checked) {
      await addCheckedItem(name);
    }

    _groceriesList.updateCheck(index, checked: checked);
    await Vibration.vibrate(duration: 100);
  }

  Future<bool> refreshGroceries() => _groceriesList.refresh();

  Future<String> removeItemGroceries(int index) async {
    pendingAPI.value = true;
    var error = "";
    final groceriesList = _groceriesList.items..removeAt(index);

    if (await updateNetworkGroceries(groceriesList)) {
      await _groceriesList.removeItem(index);
    } else {
      error = unknownError;
    }
    pendingAPI.value = false;
    return error;
  }

  Future<String> resetGroceries() async {
    pendingAPI.value = true;
    var error = "";

    if ((await getCheckedItems()).isEmpty) {
      error = "Sélectionne les articles que tu veux supprimer.";
    } else if (await resetNetworkGroceries(await getCheckedItems())) {
      await _groceriesList.refresh();
    } else {
      error = unknownError;
    }

    pendingAPI.value = false;
    return error;
  }

  openAddItemPopup({required bool open}) {
    addItemPopup.add(open);
  }

  openClearListPopup({required bool open}) {
    clearListPopup.add(open);
  }

  closeListeners() async {
    await addItemPopup.close();
  }
}
