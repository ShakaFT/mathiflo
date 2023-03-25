import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:mathiflo/config.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/localstore/groceries.dart';
import 'package:mathiflo/src/model/Groceries/groceries.dart';
import 'package:mathiflo/src/model/Groceries/groceries_item.dart';
import 'package:mathiflo/src/model/Groceries/groceries_list.dart';
import 'package:mathiflo/src/view/Groceries/widgets/item_popup.dart';
import 'package:mathiflo/src/widgets/popups.dart';
import 'package:mathiflo/src/widgets/texts.dart';
import 'package:vibration/vibration.dart';

// ignore: must_be_immutable
class ListItemWidget extends HookWidget {
  const ListItemWidget({super.key, required this.list});

  final GroceriesListNotifier list;

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
                        color: items[index].checked
                            ? const Color.fromARGB(255, 226, 224, 224)
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _listContent(context, index, items),
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      final checkedItems = await getCheckedItems();
                      if (checkedItems.contains(items[index].name)) {
                        await removeCheckedItem(items[index].name);
                        list.updateCheck(index, checked: false);
                        await Vibration.vibrate(duration: 100);
                      }
                    },
                    onLongPress: () async {
                      final checkedItems = await getCheckedItems();
                      if (!checkedItems.contains(items[index].name)) {
                        await addCheckedItem(items[index].name);
                        list.updateCheck(index);
                        await Vibration.vibrate(duration: 100);
                      }
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

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child:
              items[index].checked ? Icon(Icons.check, color: mainColor) : null,
        ),
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
          pendingAPI.value = true;
          final groceriesList = [...list.items]..removeAt(index);
          if (await updateNetworkGroceries(groceriesList)) {
            await list.removeItem(index);
          } else {
            // ignore: use_build_context_synchronously
            snackbar(context, unknownError, error: true);
          }
          pendingAPI.value = false;
        },
      ),
    );
  }
}
