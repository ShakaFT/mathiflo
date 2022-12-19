import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:utils_app/constants.dart';
import 'package:utils_app/models/groceries_list.dart';
import 'package:utils_app/widgets/app_bar_button.dart';
import 'package:utils_app/widgets/groceries/add_item_popup.dart';
import 'package:utils_app/widgets/groceries/list_item_widget.dart';
import 'package:utils_app/widgets/navigation_drawer.dart';

class GroceriesView extends HookWidget {
  GroceriesView({super.key});

  final list = GroceriesListNotifier();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Liste de courses", style: TextStyle(color: textColor)),
          backgroundColor: mainColor,
        ),
        // --> ListView with groceries list items
        body: StateNotifierBuilder(
          stateNotifier: list,
          builder: (context, value, _) => ListItemWidget(items: value),
        ),
        // --> Button to add item
        bottomNavigationBar: BottomAppBar(
          color: mainColor,
          child: AppBarButton(
            text: "Ajouter un article",
            onPressed: () async {
              await addItemClick(context);
            },
          ),
        ),
        drawer: const NavigationDrawer(),
      );

  Future<void> addItemClick(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AddItemPopup(
        list: list,
      ),
    );
  }
}
