import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/models/groceries_item.dart';
import 'package:mathiflo/models/groceries_list.dart';
import 'package:mathiflo/network/groceries.dart';
import 'package:mathiflo/widgets/buttons.dart';

// --> Style of Handle Item Popup

// ! If index == -1 --> It's a popup that allows to AddItem, else it's a popup that allows to EditItem

class HandleItemPopup extends StatefulWidget {
  const HandleItemPopup({
    super.key,
    required this.list,
    required this.index,
    required this.item,
  });

  final GroceriesListNotifier list;
  final int index;
  final Item item;

  @override
  State<HandleItemPopup> createState() => _HandleItemPopupState();
}

class _HandleItemPopupState extends State<HandleItemPopup> {
  late GroceriesListNotifier list;
  late int index;
  late Item item;
  late TextEditingController nameController;

  late String quantity;

  String nameError = "";
  String apiError = "";
  bool inProcess = false; // true during API calls

  @override
  void initState() {
    super.initState();

    list = widget.list;
    index = widget.index;
    item = widget.item;

    nameController = TextEditingController(text: item.name);
    quantity = item.quantity.toString();
  }

  @override
  Widget build(BuildContext context) => StatefulBuilder(
        builder: (context, setPopupState) => AlertDialog(
          title: Text(
            index == -1
                ? "Ajouter un article"
                : "Modifier l'article ${item.name}",
            style: TextStyle(color: popupColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
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
                    quantity == "1"
                        ? null
                        : () {
                            _decrementQuantity(setPopupState);
                          },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      15,
                    ),
                    child: Text(
                      quantity,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  plusButton(
                    quantity == "9"
                        ? null
                        : () {
                            _incrementQuantity(setPopupState);
                          },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: button(
                  index == -1 ? "Ajouter" : "Modifier",
                  _disableButton()
                      ? null
                      : () async {
                          if (await _updateGroceriesList(setPopupState) ==
                              true) {
                            Navigator.pop(context); // close popup
                          }
                        },
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

  // Front methods

  void _decrementQuantity(setPopupState) {
    if (quantity == "1") return;
    setPopupState(() {
      quantity = (int.parse(quantity) - 1).toString();
    });
  }

  void _incrementQuantity(setPopupState) {
    if (quantity == "9") return;
    setPopupState(() {
      quantity = (int.parse(quantity) + 1).toString();
    });
  }

  void _updateNameError() {
    final name = nameController.text.trim().toUpperCase();
    if (name.isEmpty) {
      nameError = "Vous devez inscrire un nom";
    } else if (list.exists(name) && name != item.name) {
      nameError = "Cet article existe déjà";
    } else {
      nameError = "";
    }
  }

  // Action methods

  Future<bool> _updateGroceriesList(setPopupState) async {
    inProcess = true;

    final item =
        Item(nameController.text.trim().toUpperCase(), int.parse(quantity));

    final groceriesList = [...list.items];
    if (index >= 0) {
      groceriesList.removeAt(index);
    }
    groceriesList.add(item);

    if (await updateNetworkGroceries(groceriesList) == true) {
      if (index == -1) {
        list.addItem(item);
      } else {
        list.replaceItem(index, item);
      }
      inProcess = false;
      return true;
    }
    setPopupState(() {
      apiError = unknownError;
    });
    inProcess = false;
    return false;
  }

  // Util methods

  bool _disableButton() =>
      nameError.isNotEmpty || nameController.text.trim().isEmpty || inProcess;
}
