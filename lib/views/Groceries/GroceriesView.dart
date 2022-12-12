import 'package:flutter/material.dart';
import 'package:utils_app/data/item.dart';
import 'package:utils_app/widgets/groceries/ListItemWidget.dart';
import '../../constants.dart';
import '../../data/data.dart';
import '../../widgets/NavigationDrawer.dart';

class GroceriesView extends StatefulWidget {
  const GroceriesView({super.key});
  _GroceriesViewState createState() => _GroceriesViewState();
}

class _GroceriesViewState extends State<GroceriesView> {
  List<Item> listItems = Data.groceries.values.toList().cast<Item>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste de courses"),
        backgroundColor: mainColor,
      ),
      // --> ListView with groceries list items
      body: ListItemWidget(items: listItems),
      // --> Button to add item
      bottomNavigationBar: BottomAppBar(
        color: mainColor,
        child: TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () {
            // --> Popup to add item
            showDialog(
                context: context,
                builder: (context) {
                  String nameError = "";
                  return StatefulBuilder(builder: (context, setPopupState) {
                    return AlertDialog(
                      title: const Text('Ajouter un article'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            controller: nameController,
                            onChanged: (value) {
                              setPopupState(() {
                                if (value.isEmpty) {
                                  nameError = "Vous devez inscrire un nom";
                                } else if (Data.itemExists(
                                    nameController.text.toString())) {
                                  nameError = "Cet article existe déjà";
                                } else {
                                  nameError = "";
                                }
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Nom de l'article",
                              errorText: nameError,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton(
                                mini: true,
                                onPressed: () {},
                                child: const Icon(Icons.remove),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(
                                    15), //apply padding to all four sides
                                child: Text("1"),
                              ),
                              FloatingActionButton(
                                mini: true,
                                onPressed: () {},
                                child: const Icon(Icons.add),
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (nameError.isNotEmpty) return;
                                  // Add in local database
                                  await Data.groceries.put(
                                      nameController.text,
                                      Item(
                                          name: nameController.text,
                                          quantity: int.parse(
                                              quantityController.text),
                                          lastUpdate: DateTime.now()
                                              .millisecondsSinceEpoch));
                                  setState(() {
                                    // refresh listItems
                                    listItems = Data.groceries.values
                                        .toList()
                                        .cast<Item>();
                                    // refresh popup
                                    nameController.text = "";
                                    quantityController.text = "";
                                  });
                                  Navigator.pop(context); // close popup
                                },
                                child: const Text("Ajouter"),
                              ))
                        ],
                      ),
                    );
                  });
                });
          },
          child: const Text('Ajouter un article'),
        ),
      ),
      drawer: const NavigationDrawer(),
    );
  }
}
