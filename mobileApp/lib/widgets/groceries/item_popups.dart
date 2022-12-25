import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/data/data.dart';
import 'package:mathiflo/data/item.dart';
import 'package:mathiflo/models/groceries_list.dart';
import 'package:mathiflo/network/groceries.dart';
import 'package:mathiflo/widgets/flotting_action_buttons.dart';

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

    // Add in remote database
    await updateGroceries([item]);

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

class EditItemPopup extends StatefulWidget {
  const EditItemPopup({
    super.key,
    required this.list,
    required this.index,
    required this.item,
  });

  final GroceriesListNotifier list;
  final int index;
  final Item item;

  @override
  State<EditItemPopup> createState() => _EditItemPopupState();
}

class _EditItemPopupState extends State<EditItemPopup> {
  late GroceriesListNotifier list;
  late int index;
  late Item item;
  late TextEditingController nameController;

  String nameError = "";

  @override
  void initState() {
    super.initState();
    list = widget.list;
    index = widget.index;
    item = widget.item;
    nameController = TextEditingController(text: item.name);
  }

  @override
  Widget build(BuildContext context) => StatefulBuilder(
        builder: (context, setPopupState) => AlertDialog(
          title: Text(
            "Modifier l'article ${item.name}",
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
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    if (await _editItem(index, item) == false) {
                      _updateNameError(
                        setPopupState,
                      ); // add error if name is empty
                      return;
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // close popup
                  },
                  child: Text("Modifier", style: TextStyle(color: textColor)),
                ),
              )
            ],
          ),
        ),
      );

  Future<bool> _editItem(int index, Item oldItem) async {
    final newName = nameController.text.trim().toUpperCase();
    if (nameError.isNotEmpty || newName.isEmpty) return false;

    final newItem = Item(
      name: newName,
      quantity: oldItem.quantity,
      lastUpdate: DateTime.now().millisecondsSinceEpoch,
    );

    // Update Groceries Network
    oldItem.quantity = 0; // reset quantity for Network
    await updateGroceries([oldItem, newItem]);

    // Add in local database
    await groceriesBox.delete(oldItem.name);
    await groceriesBox.put(newName, newItem);
    list.replaceItem(index, newItem);

    return true;
  }

  void _updateNameError(setPopupState) {
    final name = nameController.text.trim().toUpperCase();
    setPopupState(() {
      if (name.isEmpty) {
        nameError = "Vous devez inscrire un nom";
      } else if (itemExists(name) && name != item.name) {
        nameError = "Cet article existe déjà";
      } else {
        nameError = "";
      }
    });
  }
}
