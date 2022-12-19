import 'package:flutter/material.dart';
import 'package:utils_app/data/item.dart';
import 'package:utils_app/widgets/flotting_action_buttons.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({super.key, required this.items});

  final List<Item> items;

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => Card(
          elevation: 1.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(items[index].name),
                const Spacer(),
                MinusButton(onPressed: () {}),
                Padding(
                  padding: const EdgeInsets.all(
                    15,
                  ),
                  child: Text(items[index].quantity.toString()),
                ),
                PlusButton(onPressed: () {})
              ],
            ),
          ),
        ),
      );
}
