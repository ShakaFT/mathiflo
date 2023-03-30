import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/controller/Groceries/groceries_controller.dart';
import 'package:mathiflo/src/controller/Groceries/item_popup_controller.dart';
import 'package:mathiflo/src/model/Groceries/groceries_item.dart';
import 'package:mathiflo/src/widgets/buttons.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

// ! If index == -1 --> It's a popup that allows to AddItem,
// else it's a popup that allows to EditItem

class HandleItemPopup extends StatefulWidget {
  const HandleItemPopup({
    super.key,
    required this.groceriesController,
    required this.item,
    required this.index,
  });

  final GroceriesController groceriesController;
  final Item item;
  final int index;

  @override
  State createState() => _HandleItemPopupState();
}

class _HandleItemPopupState extends StateMVC<HandleItemPopup> {
  late GroceriesController groceriesController;

  final popupController = ItemPopupController();

  String apiError = "";
  String nameError = "";

  @override
  void initState() {
    super.initState();

    groceriesController = widget.groceriesController;
    popupController
      ..item = widget.item
      ..index = widget.index;
  }

  @override
  Widget build(BuildContext context) => StatefulBuilder(
        builder: (context, setPopupState) => AlertDialog(
          title: Text(
            popupController.index == -1
                ? "Ajouter un article"
                : "Modifier l'article ${popupController.item.name}",
            style: TextStyle(color: popupColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
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
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: button(
                  popupController.index == -1 ? "Ajouter" : "Modifier",
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
              if (apiError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    apiError,
                    style: TextStyle(
                      color: errorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
