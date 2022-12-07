import 'package:flutter/material.dart';
import 'package:utils_app/utils.dart';
import 'package:utils_app/widgets/ListItemWidget.dart';
import '../../widgets/NavigationDrawer.dart';
import 'AddItemView.dart';

class GroceriesView extends StatelessWidget {
  const GroceriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste de courses"),
        backgroundColor: Colors.orange.shade700,
      ),
      body: ListItemWidget(),
      bottomNavigationBar: const BottomAppBarGroceries(),
      drawer: const NavigationDrawer(),
    );
  }
}

class BottomAppBarGroceries extends StatelessWidget {
  const BottomAppBarGroceries({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.orange.shade700,
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: () {
          navigation(context, const AddItemView());
        },
        child: const Text('Ajouter un article'),
      ),
    );
  }
}
