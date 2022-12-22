import 'package:hive_flutter/hive_flutter.dart';
import 'package:utils_app/data/item.dart';

late Box groceriesBox;

Future<void> setDatabases() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ItemAdapter());
  groceriesBox = await Hive.openBox("groceries");
}

// Groceries functions
bool itemExists(String name) => groceriesBox.get(name) != null;
