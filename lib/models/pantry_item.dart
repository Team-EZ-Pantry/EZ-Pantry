class PantryItem {
  final int id;
  final String name;
  final int quantity;

  PantryItem({
    required this.id,
    required this.name,
    required this.quantity,
  });

  // Create a PantryItem from JSON
  factory PantryItem.fromJson(Map<String, dynamic> json) {
    return PantryItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
    );
  }

  // Convert PantryItem to JSON (useful for POST requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
    };
  }
}
