import 'package:flutter/material.dart';

class AddItemView extends StatelessWidget {
  const AddItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un article"),
        backgroundColor: Colors.orange.shade700,
      ),
      body: const Text("Hello"),
    );
  }
}
