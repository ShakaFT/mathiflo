import 'package:flutter/material.dart';
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
          title: const Text('Ajouter un article'),
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
                    child: Text(quantity),
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
                    await _addItem();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // close popup
                  },
                  child: const Text("Ajouter"),
                ),
              )
            ],
          ),
        ),
      );

  Future<void> _addItem() async {
    final item = Item(
      name: nameController.text,
      quantity: int.parse(quantity),
      lastUpdate: DateTime.now().millisecondsSinceEpoch,
    );
    if (nameError.isNotEmpty) return;
    // Add in local database
    await groceriesBox.put(
      nameController.text,
      item,
    );
    list.addItem(item);
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
    setPopupState(() {
      if (nameController.text.isEmpty) {
        nameError = "Vous devez inscrire un nom";
      } else if (itemExists(nameController.text)) {
        nameError = "Cet article existe déjà";
      } else {
        nameError = "";
      }
    });
  }
}
