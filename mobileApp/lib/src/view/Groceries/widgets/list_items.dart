import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/controller/Groceries/groceries_controller.dart';
import 'package:mathiflo/src/model/Groceries/groceries_item.dart';
import 'package:mathiflo/src/view/Groceries/widgets/item_popup.dart';
import 'package:mathiflo/src/widgets/popups.dart';
import 'package:mathiflo/src/widgets/texts.dart';

// ignore: must_be_immutable
class ListItemWidget extends HookWidget {
  const ListItemWidget({super.key, required this.controller});

  final GroceriesController controller;

  @override
  Widget build(BuildContext context) => StateNotifierBuilder(
        stateNotifier: controller.groceriesList,
        builder: (context, items, _) => RefreshIndicator(
          color: mainColor,
          onRefresh: controller.refreshGroceries,
          child: items.isEmpty
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
                            children:
                                _cardItemContent(context, items[index], index),
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      await controller.checkItem(
                        items[index].name,
                        index,
                        checked: true,
                      );
                    },
                    onLongPress: () async {
                      await controller.checkItem(
                        items[index].name,
                        index,
                        checked: false,
                      );
                    },
                  ),
                ),
        ),
      );

  // Widgets Methods

  List<Widget> _cardItemContent(
    BuildContext context,
    Item item,
    int index,
  ) =>
      <Widget>[
        // Checked icon
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: item.checked ? Icon(Icons.check, color: mainColor) : null,
        ),
        // Edit button
        Padding(
          padding: const EdgeInsets.all(
            15,
          ),
          child: IconButton(
            icon: Icon(Icons.edit, color: mainColor),
            onPressed: () async {
              await _editItemPopup(context, item, index);
            },
          ),
        ),
        // Name text
        Expanded(
          child: Text(
            item.name,
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
            item.quantity.toString(),
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
            await _removeItem(context, item, index);
          },
        ),
      ];

  // Action methods

  Future<void> _editItemPopup(
    BuildContext context,
    Item item,
    int index,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => HandleItemPopup(
        groceriesController: controller,
        index: index,
        item: item,
      ),
    );
  }

  Future<void> _removeItem(BuildContext context, Item item, int index) async {
    await showDialog(
      context: context,
      builder: (context) => ConfirmationPopup(
        title: "Supprimer l'article ${item.name}",
        message:
            "Voulez-vous vraiment supprimer cet article ? L'action est irréversible.",
        confirmation: () async {
          final error = await controller.removeItemGroceries(index);
          if (error.isNotEmpty) {
            if (context.mounted) snackbar(context, error, error: true);
          }
        },
      ),
    );
  }
}
