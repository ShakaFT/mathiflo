import 'package:flutter/material.dart';
import 'package:utils_app/data/item.dart';

class ListItemWidget extends StatelessWidget {
  List<Item> items = [];

  ListItemWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(items[index].name),
                  const Spacer(),
                  FloatingActionButton(
                    mini: true,
                    onPressed: () {},
                    child: const Icon(Icons.remove),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                        15), //apply padding to all four sides
                    child: Text(items[index].quantity.toString()),
                  ),
                  FloatingActionButton(
                    mini: true,
                    onPressed: () {},
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
