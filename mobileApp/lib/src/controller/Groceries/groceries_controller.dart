// ignore_for_file: close_sinks

import 'dart:async';

import 'package:mathiflo/config.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/localstore/groceries.dart';
import 'package:mathiflo/src/model/Groceries/groceries.dart';
import 'package:mathiflo/src/model/Groceries/groceries_item.dart';
import 'package:mathiflo/src/model/Groceries/groceries_list.dart';
import 'package:state_extended/state_extended.dart';
import 'package:vibration/vibration.dart';

class GroceriesController extends StateXController {
  factory GroceriesController() => _this ??= GroceriesController._();
  GroceriesController._()
      : _groceriesList = GroceriesListNotifier(),
        super();

  // Model
  static GroceriesController? _this;
  final GroceriesListNotifier _groceriesList;

  // Bool used to lock buttons to add item (in bottom bar)
  // & button to clear checked items during api process
  bool lockButtons = false;

  // Methods
  GroceriesListNotifier get groceriesNotifier => _groceriesList;

  bool groceriesContains(String name) => _groceriesList.exists(name);

  Future<String> addGroceriesItem(Item item, int index) async {
    pendingAPI.value = true;
    await Future.delayed(const Duration(seconds: 3));
    var error = "";

    final newList = [..._groceriesList.items, item];

    if (await updateNetworkGroceries(newList)) {
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

    // We need to unpack groceriesList so as not to delete
    // the item from groceriesList
    final newList = [..._groceriesList.items, item]..removeAt(index);

    if (await updateNetworkGroceries(newList)) {
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

    if (!checkedItems.contains(name) && checked) {
      await addCheckedItem(name);
    } else if (checkedItems.contains(name) && !checked) {
      await removeCheckedItem(name);
    }

    _groceriesList.updateCheck(index, checked: checked);
    await Vibration.vibrate(duration: 100);
  }

  Future<bool> refreshGroceries() async {
    lockButtons = true;
    final worked = await _groceriesList.refresh();
    lockButtons = false;
    return worked;
  }

  Future<String> removeGroceriesItem(int index) async {
    pendingAPI.value = true;
    var error = "";

    // We need to unpack groceriesList so as not to delete
    // the item from groceriesList
    final newList = [..._groceriesList.items]..removeAt(index);

    if (await updateNetworkGroceries(newList)) {
      await _groceriesList.removeItem(index);
    } else {
      error = unknownError;
    }

    pendingAPI.value = false;
    return error;
  }

  Future<String> resetGroceries() async {
    // Remove all checked items
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
}
