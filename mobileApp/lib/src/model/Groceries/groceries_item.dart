class Item {
  Item(this.id, this.name, this.quantity);
  String id;
  String name;
  int quantity;
  bool checked = false;

  static Item fromMap(Map<String, dynamic> map) =>
      Item(map["id"], map["name"], map["quantity"]);

  Map<String, dynamic> toMap() => {"name": name, "quantity": quantity};
}
