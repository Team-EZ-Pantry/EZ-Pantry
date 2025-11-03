class PantryItemModel {
  PantryItemModel({
    required this.id,
    required this.name,
    required this.quantity,   // Made this not required to use the model in searching
    this.expirationDate, // now nullable
  });

  factory PantryItemModel.fromJson(Map<String, dynamic> json) {
    return PantryItemModel(
      id: json['product_id'] as int,
      name: json['product_name'] as String,
      quantity: json['quantity'] as int,
      expirationDate: json['expiration_date']?.toString(), // safely convert
    );
  }

  final int id;
  final String name;
  int quantity;
  final String? expirationDate; // nullable

  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'product_name': name,
      'quantity': quantity,
      'expiration_date': expirationDate,
    };
  }

  @override
  String toString() {
    return 'PantryItemModel(id: $id, name: $name, quantity: $quantity, expirationDate: $expirationDate)';
  }
}
