import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/data/data.dart';
import 'package:mathiflo/models/groceries_list.dart';
import 'package:mathiflo/network/groceries.dart';
import 'package:mathiflo/utils.dart';
import 'package:mathiflo/views/Groceries/widgets/item_popups.dart';
import 'package:mathiflo/views/Groceries/widgets/list_item_widget.dart';
import 'package:mathiflo/widgets/bar.dart';
import 'package:mathiflo/widgets/confirmation_popup.dart';
import 'package:mathiflo/widgets/navigation_drawer.dart';

useGroceriesView() => use(const _GroceriesView());

class _GroceriesView extends Hook<void> {
  const _GroceriesView();

  @override
  _GroceriesViewState createState() => _GroceriesViewState();
}

class _GroceriesViewState extends HookState<void, _GroceriesView> {
  late GroceriesListNotifier list = GroceriesListNotifier();

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: Scaffold(
          appBar: appBar("Liste de courses", icons: _appBarIcons()),
          // --> ListView with groceries list items
          body: loading(
            _loadGroceriesList,
            HookBuilder(
              builder: (context) => ListItemWidget(list: list),
            ),
          ),
          // --> Button to add item
          bottomNavigationBar: bottomBar(
            BottomAppBar(
              color: mainColor,
              child: ButtonBarButton(
                text: "Ajouter un article",
                onPressed: () async {
                  await _addItemClick(context);
                },
              ),
            ),
          ),
          drawer: const NavigationDrawer(),
        ),
        onWillPop: () async => false,
      );

  // Widget methods

  _appBarIcons() => <Widget>[
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            await _clearList(context);
          },
        ),
      ];

  // Action methods

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
        confirmation: () async {
          await resetGroceries();
          await groceriesBox.clear();
          list.clear();
        },
      ),
    );
  }

  Future<void> _loadGroceriesList() async {
    await loadNetworkGroceries();
    list.fetchLocalDatabase();
  }
}
