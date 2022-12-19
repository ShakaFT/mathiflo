import 'package:flutter/material.dart';
import 'package:utils_app/constants.dart';
import 'package:utils_app/main.dart';
import 'package:utils_app/utils.dart';
import 'package:utils_app/views/Groceries/groceries_view.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
        color: mainColor,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
      );

  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          ListTile(
            leading: const Icon(Icons.local_grocery_store),
            title: Text(
              "Liste de courses",
              style: TextStyle(color: mainColor),
            ),
            onTap: () async {
              await navigation(context, GroceriesView());
            },
          ),
        ],
      );
}
