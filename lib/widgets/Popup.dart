import 'package:flutter/material.dart';

class AddExercisePopup extends StatelessWidget {
  const AddExercisePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un article'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            onChanged: (value) {},
            decoration: const InputDecoration(hintText: "Nom de l'article"),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Ajouter"),
              ))
        ],
      ),
    );
  }
}
