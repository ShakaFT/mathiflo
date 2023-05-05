import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/controller/Groceries/groceries_controller.dart';
import 'package:mathiflo/src/view/Groceries/item_popup.dart';
import 'package:mathiflo/src/view/Groceries/list_items.dart';
import 'package:mathiflo/src/widgets/async.dart';
import 'package:mathiflo/src/widgets/bar.dart';
import 'package:mathiflo/src/widgets/navigation_drawer.dart';
import 'package:mathiflo/src/widgets/popups.dart';
import 'package:state_extended/state_extended.dart';

class GroceriesView extends StatefulWidget {
  const GroceriesView({super.key});

  @override
  State createState() => _GroceriesViewState();
}

class _GroceriesViewState extends StateX<GroceriesView> {
  _GroceriesViewState() : super(GroceriesController()) {
    _controller = controller! as GroceriesController;
  }
  late GroceriesController _controller;

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: WaitingApi(
          child: Scaffold(
            appBar: appBar("Liste de courses", icons: _appBarIcons()),
            body: FutureBuilder(
              // ignore: discarded_futures
              future: _loadGroceriesList(),
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? loader()
                      // Allow to refresh data by swiping down
                      : RefreshIndicator(
                          color: mainColor,
                          onRefresh: _loadGroceriesList,
                          child: ListItemWidget(controller: _controller),
                        ),
            ),
            // --> Button to add item
            bottomNavigationBar: bottomBar(
              child: ButtonBarButton(
                text: "Ajouter un article",
                onPressed: () async {
                  await _openAddItemPopup();
                },
              ),
            ),
            drawer: const NavigationDrawerWidget(),
          ),
        ),
        onWillPop: () async => false,
      );

  _appBarIcons() => <Widget>[
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            _openClearListPopup();
          },
        ),
      ];

  _openAddItemPopup() async {
    if (_controller.lockButtons) return;
    await showDialog(
      context: context,
      builder: (context) => GroceriesItemPopup(
        groceriesController: _controller,
      ),
    );
  }

  _openClearListPopup() async {
    if (_controller.lockButtons) return;

    if ((await _controller.checkedItems()).isEmpty) {
      if (mounted) {
        snackbar(
          context,
          "Sélectionne les articles que tu veux supprimer.",
          error: true,
        );
        return;
      }
    }

    if (mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertPopup(
          title: "Supprimer les articles",
          message: "Voulez-vous vraiment supprimer les articles sélectionnés ?",
          confirmation: () async {
            final error = await _controller.resetGroceries();
            if (error.isNotEmpty) {}
          },
        ),
      );
    }
  }

  Future<void> _loadGroceriesList() async {
    if (!await _controller.refreshGroceries()) {
      if (context.mounted) snackbar(context, unknownError, error: true);
    }
  }
}
