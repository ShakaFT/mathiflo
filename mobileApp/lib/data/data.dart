import 'package:hive_flutter/hive_flutter.dart';
import 'package:mathiflo/data/item.dart';

late Box groceriesBox;

Future<void> setDatabases() async {
  await Hive.initFlutter();

  // Set groceries

  Hive.registerAdapter(ItemAdapter());
  groceriesBox = await Hive.openBox("groceries");
}

// Groceries functions

bool itemExists(String name) => groceriesBox.get(name) != null;
