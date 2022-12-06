import 'package:flutter/material.dart';
import 'package:utils_app/views/FavoritesView.dart';
import 'package:utils_app/views/HomeView.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SingleChildScrollView(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        buildHeader(context),
        buildMenuItems(context),
      ],
    )));
  }

  Widget buildHeader(BuildContext context) => Container(
        color: Colors.blue.shade700,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
      );

  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Home"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeView()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text("Favorites"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesView()),
              );
            },
          )
        ],
      );
}
