import 'package:hive/hive.dart';

part 'item.g.dart';
// To active import, executes the following command line :
// flutter packages pub run build_runner build

@HiveType(typeId: 1)
class Item {
  Item({required this.name, required this.quantity, required this.lastUpdate});

  @HiveField(0)
  String name;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  int lastUpdate;
}
