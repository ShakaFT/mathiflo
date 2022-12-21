import 'package:flutter/material.dart';
import 'package:utils_app/constants.dart';
import 'package:utils_app/data/data.dart';
import 'package:utils_app/data/item.dart';
import 'package:utils_app/models/groceries_list.dart';
import 'package:utils_app/widgets/flotting_action_buttons.dart';

// ignore_for_file: must_be_immutable
class AddItemPopup extends StatelessWidget {
  AddItemPopup({super.key, required this.list});

  final GroceriesListNotifier list;

  final TextEditingController nameController = TextEditingController();

  String nameError = "";
  String quantity = "1";

  @override
  Widget build(BuildContext context) => StatefulBuilder(
        builder: (context, setPopupState) => AlertDialog(
          title:
              Text('Ajouter un article', style: TextStyle(color: popupColor)),
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
                  MinusButton(
                    onPressed: () {
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
                  PlusButton(
                    onPressed: () {
                      _incrementQuantity(setPopupState);
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    if (await _addItem() == false) {
                      _updateNameError(
                        setPopupState,
                      ); // add error if name is empty
                      return;
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // close popup
                  },
                  child: Text("Ajouter", style: TextStyle(color: textColor)),
                ),
              )
            ],
          ),
        ),
      );

  Future<bool> _addItem() async {
    final name = nameController.text.trim().toUpperCase();
    if (nameError.isNotEmpty || name.isEmpty) return false;

    final item = Item(
      name: name,
      quantity: int.parse(quantity),
      lastUpdate: DateTime.now().millisecondsSinceEpoch,
    );
    // Add in local database
    await groceriesBox.put(
      name,
      item,
    );
    list.addItem(item);

    return true;
  }

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
      } else if (itemExists(name)) {
        nameError = "Cet article existe déjà";
      } else {
        nameError = "";
      }
    });
  }
}
