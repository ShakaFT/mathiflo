import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:utils_app/constants.dart';
import 'package:utils_app/data/data.dart';
import 'package:utils_app/models/groceries_list.dart';
import 'package:utils_app/widgets/app_bar_button.dart';
import 'package:utils_app/widgets/confirmation_popup.dart';
import 'package:utils_app/widgets/groceries/item_popups.dart';
import 'package:utils_app/widgets/groceries/list_item_widget.dart';
import 'package:utils_app/widgets/navigation_drawer.dart';

class GroceriesView extends HookWidget {
  GroceriesView({super.key});

  final list = GroceriesListNotifier();

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Liste de courses", style: TextStyle(color: textColor)),
            backgroundColor: mainColor,
            iconTheme: IconThemeData(color: textColor),
            actions: <Widget>[
              // IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await _clearList(context);
                },
              ),
            ],
          ),
          // --> ListView with groceries list items
          body: HookBuilder(
            builder: (context) => ListItemWidget(list: list),
          ),
          // --> Button to add item
          bottomNavigationBar: BottomAppBar(
            color: mainColor,
            child: AppBarButton(
              text: "Ajouter un article",
              onPressed: () async {
                await _addItemClick(context);
              },
            ),
          ),
          drawer: const NavigationDrawer(),
        ),
        onWillPop: () async => false,
      );

  Future<void> _addItemClick(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AddItemPopup(
        list: list,
      ),
    );
  }

  Future<void> _clearList(BuildContext context) async {
    if (list.isEmpty) return;
    await showDialog(
      context: context,
      builder: (context) => ConfirmationPopup(
        title: "Vider la liste",
        text: "Voulez-vous vraiment vider la liste de courses ?",
        confirmation: () {
          groceriesBox.clear();
          list.clear();
        },
      ),
    );
  }
}
