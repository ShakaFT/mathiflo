import 'package:flutter/material.dart';
import 'package:mathiflo/src/model/Groceries/groceries_item.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class ItemPopupController extends ControllerMVC {
  factory ItemPopupController([StateMVC? state]) =>
      _this ??= ItemPopupController._(state);
  ItemPopupController._(super.state);
  static ItemPopupController? _this;

  final nameController = TextEditingController();

  late Item _item;
  late int index;

  Item get item => _item;
  set item(Item item) {
    _item = item;
    nameController.text = item.name;
  }

  String get buttonTitle => index == -1 ? "Ajouter" : "Modifier";
  String get nameControllerText => nameController.text.trim().toUpperCase();
  String get popupTitle =>
      index == -1 ? "Ajouter un article" : "Modifier l'article ${item.name}";

  bool get disabledDecrementButton => item.quantity == 1;
  bool get disabledIncrementButton => item.quantity == 9;

  void decrementQuantity() => --item.quantity;
  void incrementQuantity() => ++item.quantity;
}
