import 'package:flutter/material.dart';
import 'package:mathiflo/src/controller/Groceries/groceries_controller.dart';
import 'package:mathiflo/src/model/Groceries/groceries_item.dart';
import 'package:state_extended/state_extended.dart';

class ItemPopupController extends StateXController {
  factory ItemPopupController() => _this ??= ItemPopupController._();
  ItemPopupController._() : super();

  static ItemPopupController? _this;

  String apiError = "";
  String nameError = "";
  final nameController = TextEditingController();

  late GroceriesController groceriesController;
  late Item _item;
  late int index;

  Item get item => _item;
  set item(Item item) {
    _item = item;
    nameController.text = item.name;
  }

  String get buttonTitle => index == -1 ? "Ajouter" : "Modifier";
  String get popupTitle =>
      index == -1 ? "Ajouter un article" : "Modifier l'article ${item.name}";

  bool get disabledDecrementButton => item.quantity == 1;
  bool get disabledIncrementButton => item.quantity == 9;
  bool get disabledSendItemButton =>
      nameError.isNotEmpty || _nameControllerText.isEmpty;

  void decrementQuantity() {
    setState(() {
      --item.quantity;
    });
  }

  void incrementQuantity() {
    setState(() {
      ++item.quantity;
    });
  }

  Future<bool> sendItem() async {
    final item = Item(
      _item.id,
      _nameControllerText,
      _item.quantity,
    );

    apiError = index == -1
        ? await groceriesController.addGroceriesItem(
            item,
            index,
          )
        : await groceriesController.updateGroceriesItem(
            item,
            index,
          );
    setState(() {});
    return apiError.isEmpty;
  }

  void updateNameError() {
    setState(() {
      nameError = "";
      if (_nameControllerText.isEmpty) {
        nameError = "Vous devez inscrire un nom";
      } else if (groceriesController.groceriesContains(_nameControllerText) &&
          _nameControllerText != item.name) {
        nameError = "Cet article existe déjà";
      }
    });
  }

  // Private functions

  String get _nameControllerText => nameController.text.trim().toUpperCase();
}
