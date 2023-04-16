import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mathiflo/config.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/localstore/groceries.dart';
import 'package:mathiflo/src/model/Groceries/groceries_item.dart';
import 'package:mathiflo/src/model/Groceries/groceries_list.dart';
import 'package:mathiflo/src/model/Groceries/groceries_network.dart';
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

    final error = await addNetworkGroceriesItem(item);
    if (error.isEmpty) {
      _groceriesList.addItem(item);
    }

    pendingAPI.value = false;
    return error;
  }

  Future<List<String>> checkedItems() async => getCheckedItems();

  Future<String> updateGroceriesItem(Item item, int index) async {
    pendingAPI.value = true;

    final error = await updateNetworkGroceriesItem(item);
    if (error.isEmpty) {
      await _groceriesList.replaceItem(index, item);
    }

    pendingAPI.value = false;
    return error;
  }

  Future<void> checkItem(
    String id,
    int index, {
    required bool checked,
  }) async {
    final checkedItems = await getCheckedItems();

    if (!checkedItems.contains(id) && checked) {
      await addCheckedItem(id);
      await _udateCheckItem(index, checked: checked);
    } else if (checkedItems.contains(id) && !checked) {
      await removeCheckedItem(id);
      await _udateCheckItem(index, checked: checked);
    }
  }

  Future<bool> refreshGroceries() async {
    lockButtons = true;
    final worked = await _groceriesList.refresh();
    lockButtons = false;
    return worked;
  }

  Future<String> removeGroceriesItem(Item item, int index) async {
    pendingAPI.value = true;
    var error = "";

    if (await deleteNetworkGroceriesItems([item.id])) {
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

    if (await deleteNetworkGroceriesItems(await getCheckedItems())) {
      await _groceriesList.refresh();
    } else {
      error = unknownError;
    }

    pendingAPI.value = false;
    return error;
  }

  Future<void> _udateCheckItem(int index, {required bool checked}) async {
    try {
      await Vibration.vibrate(duration: 100);
      // Empty block to skip MissingPluginException if device has not vibration plugin
      // ignore: empty_catches
    } on MissingPluginException {}
    _groceriesList.updateCheck(index, checked: checked);
  }
}
