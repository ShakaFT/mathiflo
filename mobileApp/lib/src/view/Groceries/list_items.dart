import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/controller/Groceries/groceries_controller.dart';
import 'package:mathiflo/src/model/Groceries/groceries_item.dart';
import 'package:mathiflo/src/view/Groceries/item_popup.dart';
import 'package:mathiflo/src/widgets/popups.dart';
import 'package:mathiflo/src/widgets/texts.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({super.key, required this.controller});

  final GroceriesController controller;

  @override
  Widget build(BuildContext context) => StateNotifierBuilder(
        stateNotifier: controller.groceriesNotifier,
        builder: (context, items, _) => items.isEmpty
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
                    final item = items[index];
                    await controller.checkItem(
                      item.id,
                      index,
                      checked: (await controller.checkedItems()).isNotEmpty &&
                          !item.checked,
                    );
                  },
                  onLongPress: () async {
                    await controller.checkItem(
                      items[index].id,
                      index,
                      checked: true,
                    );
                  },
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
              await _openUpdateItemPopup(context, item, index);
            },
          ),
        ),
        // Name
        Expanded(
          child: Text(
            item.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(
            15,
          ),
          // Quantity
          child: Text(
            item.quantity.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Remove button
        IconButton(
          icon: const Icon(
            Icons.close,
            color: errorColor,
          ),
          onPressed: () async {
            await _openRemoveItemPopup(context, item, index);
          },
        ),
      ];

  _openRemoveItemPopup(BuildContext context, Item item, int index) async {
    await showDialog(
      context: context,
      builder: (context) => AlertPopup(
        title: "Supprimer l'article ${item.name}",
        message:
            "Voulez-vous vraiment supprimer cet article ? L'action est irréversible.",
        confirmation: () async {
          final error = await controller.removeGroceriesItem(item, index);
          if (error.isNotEmpty) {
            if (context.mounted) snackbar(context, error, error: true);
          }
        },
      ),
    );
  }

  _openUpdateItemPopup(BuildContext context, Item item, int index) async {
    await showDialog(
      context: context,
      builder: (context) => GroceriesItemPopup(
        groceriesController: controller,
        index: index,
        item: item,
      ),
    );
  }
}
