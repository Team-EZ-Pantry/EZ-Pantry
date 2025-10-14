class PantryItemModel {

  PantryItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.expirationDate,
  });

  // Create a PantryItem from JSON
  factory PantryItemModel.fromJson(Map<String, dynamic> json) {
    return PantryItemModel(
      id: json['product_id'] as int,
      name: json['product_name'] as String,
      quantity: json['quantity'] as int,
      expirationDate: json['expiration_date'] as String
    );
  }

  final int id;
  final String name;
  final int quantity;
  final String expirationDate;

  // Convert PantryItem to JSON (useful for POST requests)
  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'product_name': name,
      'quantity': quantity,
      'expirationDate': expirationDate,
    };
  }

  @override
  String toString() {
    return 'PantryItemModel(id: $id, name: $name, quantity: $quantity, expirationDate: $expirationDate)';
  }
}

