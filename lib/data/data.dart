import 'package:hive_flutter/hive_flutter.dart';
import 'package:utils_app/data/item.dart';

class Data {
  static late Box groceries;

  static setDatabases() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ItemAdapter());
    groceries = await Hive.openBox("groceries");
  }

  // Groceries methods

  static bool itemExists(String name) {
    return groceries.get(name) != null;
  }
}
