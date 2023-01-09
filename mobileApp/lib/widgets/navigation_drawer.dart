import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/utils.dart';
import 'package:mathiflo/views/Groceries/groceries_view.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildHeader(context),
              _buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget _buildHeader(BuildContext context) => Container(
        color: mainColor,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
      );

  // tabs in sidebar

  Widget _buildMenuItems(BuildContext context) => Column(
        children: [
          _tab(
            context,
            "Liste de courses",
            const Icon(Icons.local_grocery_store),
            HookBuilder(
              builder: (context) => useGroceriesView(),
            ),
          ),

          // -----------------------------

          // ...
        ],
      );

  // tab style

  ListTile _tab(BuildContext context, String title, Icon icon, Widget view) =>
      ListTile(
        leading: icon,
        title: Text(
          title,
          style: TextStyle(color: mainColor),
        ),
        onTap: () async {
          await navigation(
            context,
            view,
          );
        },
      );
}
