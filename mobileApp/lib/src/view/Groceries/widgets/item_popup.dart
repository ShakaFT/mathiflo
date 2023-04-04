import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/controller/Groceries/groceries_controller.dart';
import 'package:mathiflo/src/controller/Groceries/item_popup_controller.dart';
import 'package:mathiflo/src/model/Groceries/groceries_item.dart';
import 'package:mathiflo/src/widgets/buttons.dart';
import 'package:mathiflo/src/widgets/texts.dart';
import 'package:state_extended/state_extended.dart';

// ! If index == -1 --> It's a popup that allows to AddItem,
// else it's a popup that allows to EditItem

class GroceriesItemPopup extends StatefulWidget {
  const GroceriesItemPopup({
    super.key,
    required this.groceriesController,
    this.item,
    this.index,
  });

  final GroceriesController groceriesController;
  final Item? item;
  final int? index;

  @override
  State createState() => _GroceriesItemPopupState();
}

class _GroceriesItemPopupState extends StateX<GroceriesItemPopup> {
  _GroceriesItemPopupState() : super(ItemPopupController()) {
    popupController = controller! as ItemPopupController;
    popupController.nameError = "";
  }
  late ItemPopupController popupController;

  @override
  void initState() {
    super.initState();

    popupController
      ..groceriesController = widget.groceriesController
      ..item = widget.item ?? Item(Uuid().generateV4(), "", 1)
      ..index = widget.index ?? -1;
  }

  @override
  Widget build(BuildContext context) => StatefulBuilder(
        builder: (context, setPopupState) => AlertDialog(
          title: Text(
            popupController.popupTitle,
            style: TextStyle(color: popupColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // TextField to change name
              TextField(
                controller: popupController.nameController,
                textCapitalization: TextCapitalization.characters, // upperCase
                onChanged: (_) {
                  popupController.updateNameError();
                },
                decoration: InputDecoration(
                  hintText: "Nom de l'article",
                  errorText: popupController.nameError,
                ),
              ),
              // Quantity
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  minusButton(
                    popupController.decrementQuantity,
                    disabled: popupController.disabledDecrementButton,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      15,
                    ),
                    child: Text(
                      popupController.item.quantity.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  plusButton(
                    popupController.incrementQuantity,
                    disabled: popupController.disabledIncrementButton,
                  ),
                ],
              ),
              // Button to send Item
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: button(
                  popupController.buttonTitle,
                  () async {
                    if (await popupController.sendItem()) {
                      if (mounted) Navigator.pop(context); // close popup
                    }
                  },
                  disabled: popupController.disabledSendItemButton,
                ),
              ),
              if (popupController.apiError.isNotEmpty)
                errorText(popupController.apiError)
            ],
          ),
        ),
      );
}
