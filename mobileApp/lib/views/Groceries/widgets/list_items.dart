import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/models/groceries_item.dart';
import 'package:mathiflo/models/groceries_list.dart';
import 'package:mathiflo/network/groceries.dart';
import 'package:mathiflo/views/Groceries/widgets/item_popup.dart';
import 'package:mathiflo/widgets/popups.dart';
import 'package:mathiflo/widgets/texts.dart';

// ignore: must_be_immutable
class ListItemWidget extends HookWidget {
  ListItemWidget({super.key, required this.list});

  final GroceriesListNotifier list;
  bool checked = false;

  @override
  Widget build(BuildContext context) => StateNotifierBuilder(
        stateNotifier: list,
        builder: (context, items, _) => RefreshIndicator(
          color: mainColor,
          onRefresh: _refresh,
          child: list.isEmpty
              ? scrollableText("La liste de courses est vide")
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => GestureDetector(
                    child: Card(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOut,
                        color: checked ? Colors.grey : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _listContent(context, index, items),
                          ),
                        ),
                      ),
                    ),
                    onDoubleTap: () {
                      checked = !checked;
                      list.notify();
                    },
                  ),
                ),
        ),
      );

  // Widgets Methods

  List<Widget> _listContent(
    BuildContext context,
    int index,
    List<Item> items,
  ) =>
      <Widget>[
        // Edit button
        if (checked == true) Icon(Icons.check, color: mainColor),
        Padding(
          padding: const EdgeInsets.all(
            15,
          ),
          child: IconButton(
            icon: Icon(Icons.edit, color: mainColor),
            onPressed: () async {
              await _editItemPopup(context, index, items[index]);
            },
          ),
        ),
        // Name text
        Expanded(
          child: Text(
            items[index].name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        // Quantity text
        Padding(
          padding: const EdgeInsets.all(
            15,
          ),
          child: Text(
            items[index].quantity.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Remove button
        IconButton(
          icon: Icon(
            Icons.close,
            color: errorColor,
          ),
          onPressed: () async {
            await _removeItem(context, index, items[index]);
          },
        ),
      ];

  // Action methods

  Future<void> _editItemPopup(
    BuildContext context,
    int index,
    Item item,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => HandleItemPopup(
        list: list,
        index: index,
        item: item,
      ),
    );
  }

  Future<void> _refresh() async {
    if (!await list.refresh()) {}
  }

  Future<void> _removeItem(BuildContext context, int index, Item item) async {
    await showDialog(
      context: context,
      builder: (context) => ConfirmationPopup(
        title: "Supprimer l'article ${item.name}",
        message:
            "Voulez-vous vraiment supprimer cet article ? L'action est irréversible.",
        confirmation: () async {
          final groceriesList = [...list.items]..removeAt(index);
          if (await updateNetworkGroceries(groceriesList)) {
            list.removeItem(index);
          } else {
            // ignore: use_build_context_synchronously
            snackbar(context, unknownError, error: true);
          }
        },
      ),
    );
  }
}
