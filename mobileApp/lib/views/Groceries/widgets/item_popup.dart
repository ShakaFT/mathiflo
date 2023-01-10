import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/models/groceries_item.dart';
import 'package:mathiflo/models/groceries_list.dart';
import 'package:mathiflo/network/groceries.dart';
import 'package:mathiflo/widgets/flotting_action_buttons.dart';

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
                onChanged: (_) {
                  _updateNameError(setPopupState);
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
                child: ElevatedButton(
                  onPressed: !_formIsValid()
                      ? null
                      : () async {
                          if (await _updateGroceriesList() == false) {
                            _updateNameError(
                              setPopupState,
                            ); // add error if name is empty
                            return;
                          }
                          Navigator.pop(context); // close popup
                        },
                  child: Text("Modifier", style: TextStyle(color: textColor)),
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

  void _updateNameError(setPopupState) {
    final name = nameController.text.trim().toUpperCase();
    setPopupState(() {
      if (name.isEmpty) {
        nameError = "Vous devez inscrire un nom";
      } else if (list.exists(name) && name != item.name) {
        nameError = "Cet article existe déjà";
      } else {
        nameError = "";
      }
    });
  }

  // Action methods

  Future<bool> _updateGroceriesList() async {
    if (!_formIsValid()) return false;

    final item =
        Item(nameController.text.trim().toUpperCase(), int.parse(quantity));

    // Add in remote database
    if (index == -1) {
      list.addItem(item);
    } else {
      list.replaceItem(index, item);
    }
    await updateNetworkGroceries(list.items);

    // Add in groceries list

    return true;
  }

  // Util methods

  bool _formIsValid() =>
      nameError.isEmpty && nameController.text.trim().isNotEmpty;
}
