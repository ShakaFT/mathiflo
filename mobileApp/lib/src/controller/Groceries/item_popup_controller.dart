import 'package:flutter/material.dart';
import 'package:mathiflo/src/model/Groceries/groceries_item.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class ItemPopupController extends ControllerMVC {
  factory ItemPopupController([StateMVC? state]) =>
      _this ??= ItemPopupController._(state);
  ItemPopupController._(super.state);
  static ItemPopupController? _this;

  late Item? _item;
  int index = 0;
  final nameController = TextEditingController();

  Item get item => _item!;
  set item(Item item) {
    _item = item;
    nameController.text = item.name;
  }

  String get nameControllerText => nameController.text.trim().toUpperCase();

  bool get disabledDecrementButton => item.quantity == 1;
  bool get disabledIncrementButton => item.quantity == 9;

  void decrementQuantity() => --item.quantity;
  void incrementQuantity() => ++item.quantity;
}
