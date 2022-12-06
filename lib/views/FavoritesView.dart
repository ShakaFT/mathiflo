import 'package:flutter/material.dart';
import '../widgets/NavigationDrawer.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites Page"),
        backgroundColor: Colors.blue.shade700,
      ),
      drawer: const NavigationDrawer(),
    );
  }
}
