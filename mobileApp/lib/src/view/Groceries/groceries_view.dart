import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/controller/Groceries/groceries_controller.dart';
import 'package:mathiflo/src/model/Groceries/groceries_item.dart';
import 'package:mathiflo/src/view/Groceries/widgets/item_popup.dart';
import 'package:mathiflo/src/view/Groceries/widgets/list_items.dart';
import 'package:mathiflo/src/widgets/async.dart';
import 'package:mathiflo/src/widgets/bar.dart';
import 'package:mathiflo/src/widgets/navigation_drawer.dart';
import 'package:mathiflo/src/widgets/popups.dart';

// useGroceriesView() => use(const _GroceriesView());

class GroceriesView extends StatefulWidget {
  const GroceriesView({super.key});

  @override
  State<GroceriesView> createState() => _GroceriesViewState();
}

class _GroceriesViewState extends State<GroceriesView> {
  final GroceriesController _controller = GroceriesController();

  @override
  void initState() {
    super.initState();
    _listen();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.closeListeners();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: WaitingApi(
          child: Scaffold(
            appBar: appBar("Liste de courses", icons: _appBarIcons()),
            body: FutureBuilder(
              future: _loadGroceriesList(),
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? circularProgressIndicator()
                      : HookBuilder(
                          builder: (context) =>
                              ListItemWidget(controller: _controller),
                        ),
            ),
            // --> Button to add item
            bottomNavigationBar: bottomBar(
              child: ButtonBarButton(
                text: "Ajouter un article",
                onPressed: () async {
                  await _controller.openAddItemPopup(open: true);
                },
              ),
            ),
            drawer: const NavigationDrawerWidget(),
          ),
        ),
        onWillPop: () async => false,
      );

  // Widget methods

  _appBarIcons() => <Widget>[
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            _controller.openClearListPopup(open: true);
          },
        ),
      ];

  // Action methods

  _listen() {
    _controller.addItemPopup.stream.listen((addItemPopup) async {
      if (addItemPopup) {
        await showDialog(
          context: context,
          builder: (context) => HandleItemPopup(
            groceriesController: _controller,
            index: -1,
            item: Item("", 1),
          ),
        );
      }
    });

    _controller.clearListPopup.stream.listen((clearListPopup) async {
      if (!clearListPopup) return;

      await showDialog(
        context: context,
        builder: (context) => ConfirmationPopup(
          title: "Supprimer les articles",
          message: "Voulez-vous vraiment supprimer les articles sélectionnés ?",
          confirmation: () async {
            final error = await _controller.resetGroceries();
            if (error.isNotEmpty) {
              if (context.mounted) snackbar(context, error, error: true);
            }
          },
        ),
      );
    });
  }

  Future<void> _loadGroceriesList() async {
    if (!await _controller.refreshGroceries()) {
      if (context.mounted) snackbar(context, unknownError, error: true);
    }
  }
}