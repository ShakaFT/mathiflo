import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/controller/Groceries/groceries_controller.dart';
import 'package:mathiflo/src/controller/Groceries/item_popup_controller.dart';
import 'package:mathiflo/src/model/Groceries/groceries_item.dart';
import 'package:mathiflo/src/widgets/buttons.dart';
import 'package:mathiflo/src/widgets/texts.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

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

class _GroceriesItemPopupState extends StateMVC<GroceriesItemPopup> {
  final popupController = ItemPopupController();

  String apiError = "";
  String nameError = "";

  late GroceriesController groceriesController;

  @override
  void initState() {
    super.initState();

    groceriesController = widget.groceriesController;
    popupController
      ..item = widget.item ?? Item("", 1)
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
                  setPopupState(_updateNameError);
                },
                decoration: InputDecoration(
                  hintText: "Nom de l'article",
                  errorText: nameError,
                ),
              ),
              // Quantity
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  minusButton(
                    () {
                      setState(popupController.decrementQuantity);
                    },
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
                    () {
                      setState(popupController.incrementQuantity);
                    },
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
                    final item = Item(
                      popupController.nameControllerText,
                      popupController.item.quantity,
                    );
                    final error = popupController.index == -1
                        ? await groceriesController.addGroceriesItem(
                            item,
                            popupController.index,
                          )
                        : await groceriesController.updateGroceriesItem(
                            item,
                            popupController.index,
                          );
                    setState(() {
                      apiError = error;
                    });

                    if (apiError.isEmpty) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context); // close popup
                    }
                  },
                  disabled: nameError.isNotEmpty ||
                      popupController.nameControllerText.isEmpty,
                ),
              ),
              if (apiError.isNotEmpty) errorText(apiError)
            ],
          ),
        ),
      );

  void _updateNameError() {
    final name = popupController.nameControllerText;
    if (name.isEmpty) {
      nameError = "Vous devez inscrire un nom";
    } else if (groceriesController.groceriesContains(name) &&
        name != popupController.item.name) {
      nameError = "Cet article existe déjà";
    } else {
      nameError = "";
    }
  }
}
