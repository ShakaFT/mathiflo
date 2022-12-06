import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final items = [
    "List 1",
    "List 2",
    "List 3",
    "List 1",
    "List 2",
    "List 3",
    "List 1",
    "List 2",
    "List 3",
    "List 1",
    "List 2",
    "List 3"
  ];

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
                  Text("Item Name"),
                  Spacer(),
                  FloatingActionButton(
                    mini: true,
                    onPressed: () {},
                    child: Icon(Icons.remove),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text("0"),
                  ),
                  FloatingActionButton(
                    mini: true,
                    onPressed: () {},
                    child: Icon(Icons.add),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
