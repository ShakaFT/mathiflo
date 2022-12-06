import 'package:flutter/material.dart';
import 'package:utils_app/widgets/ListItem.dart';
import '../widgets/NavigationDrawer.dart';

class GroceriesView extends StatelessWidget {
  const GroceriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste de courses"),
        backgroundColor: Colors.orange.shade700,
      ),
      body: ListItem(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange.shade700,
        child: TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () {},
          child: Text('Ajouter un article'),
        ),
      ),
      drawer: const NavigationDrawer(),
    );
  }
}
