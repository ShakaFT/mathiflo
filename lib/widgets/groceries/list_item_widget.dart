import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:utils_app/data/data.dart';
import 'package:utils_app/data/item.dart';
import 'package:utils_app/models/groceries_list.dart';
import 'package:utils_app/widgets/confirmation_popup.dart';
import 'package:utils_app/widgets/flotting_action_buttons.dart';

// ignore: must_be_immutable
class ListItemWidget extends HookWidget {
  const ListItemWidget({super.key, required this.list});

  final GroceriesListNotifier list;

  @override
  Widget build(BuildContext context) => StateNotifierBuilder(
        stateNotifier: list,
        builder: (context, items, _) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => Card(
            elevation: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(
                      15,
                    ),
                    child: Icon(Icons.edit),
                  ),
                  Expanded(
                    //width: context.width * 0.9, // we are letting the text to take 90% of screen width
                    child: Text(
                      items[index].name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  MinusButton(
                    onPressed: () async {
                      await _decrementQuantity(context, index, items[index]);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      15,
                    ),
                    child: Text(
                      items[index].quantity.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  PlusButton(
                    onPressed: () async {
                      await _incrementQuantity(index, items[index]);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> _decrementQuantity(
    BuildContext context,
    int index,
    Item oldItem,
  ) async {
    if (oldItem.quantity == 1) {
      await showDialog(
        context: context,
        builder: (context) => ConfirmationPopup(
          title: "Supprimer un article",
          text: "Voulez-vous vraiment supprimer l'article ${oldItem.name} ?",
          confirmation: () {
            _removeItem(index, oldItem);
          },
        ),
      );
      return;
    }

    final newItem = Item(
      name: oldItem.name,
      quantity: oldItem.quantity - 1,
      lastUpdate: DateTime.now().millisecondsSinceEpoch,
    );

    await groceriesBox.put(newItem.name, newItem);
    list.replaceItem(index, newItem);
  }

  Future<void> _incrementQuantity(int index, Item oldItem) async {
    if (oldItem.quantity == 9) return;

    final newItem = Item(
      name: oldItem.name,
      quantity: oldItem.quantity + 1,
      lastUpdate: DateTime.now().millisecondsSinceEpoch,
    );

    await groceriesBox.put(newItem.name, newItem);
    list.replaceItem(index, newItem);
  }

  Future<void> _removeItem(int index, Item item) async {
    await groceriesBox.delete(item.name);
    list.removeItem(index);
  }
}
