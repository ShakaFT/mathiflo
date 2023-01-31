import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/utils.dart';
import 'package:mathiflo/views/CuddlyToys/cuddly_toys_view.dart';
import 'package:mathiflo/views/Groceries/groceries_view.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

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
            Icon(Icons.local_grocery_store, color: mainColor),
            HookBuilder(
              builder: (context) => useGroceriesView(),
            ),
          ),

          // -----------------------------

          _tab(
            context,
            "Doudous",
            Icon(Icons.living_rounded, color: mainColor),
            HookBuilder(
              builder: (context) => useCuddlyToysView(),
            ),
          ),

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
