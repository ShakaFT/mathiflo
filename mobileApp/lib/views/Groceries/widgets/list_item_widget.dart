import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:mathiflo/models/groceries_item.dart';
import 'package:mathiflo/models/groceries_list.dart';
import 'package:mathiflo/network/groceries.dart';
import 'package:mathiflo/views/Groceries/widgets/item_popups.dart';
import 'package:mathiflo/widgets/confirmation_popup.dart';
import 'package:mathiflo/widgets/flotting_action_buttons.dart';

// ignore: must_be_immutable
class ListItemWidget extends HookWidget {
  const ListItemWidget({super.key, required this.list});

  final GroceriesListNotifier list;

  @override
  Widget build(BuildContext context) => StateNotifierBuilder(
        stateNotifier: list,
        builder: (context, items, _) => RefreshIndicator(
          onRefresh: _refresh,
          child: list.isEmpty
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text("La liste de course est vide"),
                    ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => Card(
                    elevation: 1.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(
                              15,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await _editItem(context, index, items[index]);
                              },
                            ),
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
                              await _decrementQuantity(
                                context,
                                index,
                                items[index],
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(
                              15,
                            ),
                            child: Text(
                              items[index].quantity.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
          message: "Voulez-vous vraiment supprimer l'article ${oldItem.name} ?",
          confirmation: () {
            _removeItem(index, oldItem);
          },
        ),
      );
      return;
    }

    final newItem = Item(oldItem.name, oldItem.quantity - 1);

    await updateNetworkGroceries([newItem]);
    list.replaceItem(index, newItem);
  }

  Future<void> _editItem(BuildContext context, int index, Item item) async {
    await showDialog(
      context: context,
      builder: (context) => EditItemPopup(list: list, index: index, item: item),
    );
  }

  Future<void> _incrementQuantity(int index, Item oldItem) async {
    if (oldItem.quantity == 9) return;

    final newItem = Item(oldItem.name, oldItem.quantity + 1);

    await updateNetworkGroceries([newItem]);
    list.replaceItem(index, newItem);
  }

  Future<void> _refresh() async {
    if (await list.refresh()) {
      return;
    }
    // TODO Add error handling !!!
  }

  Future<void> _removeItem(int index, Item item) async {
    item.quantity = 0;
    await updateNetworkGroceries([item]);
    list.removeItem(index);
  }
}
