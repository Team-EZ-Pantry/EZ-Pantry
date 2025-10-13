class PantryItemModel {

  PantryItemModel({
    required this.id,
    required this.name,
    required this.quantity,
  });

  // Create a PantryItem from JSON
  factory PantryItemModel.fromJson(Map<String, dynamic> json) {
    return PantryItemModel(
      id: json['pantry_id'] as int,
      name: json['display_name'] as String,
      quantity: json['quantity'] as int,
    );
  }

  final int id;
  final String name;
  final int quantity;

  // Convert PantryItem to JSON (useful for POST requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': name,
      'quantity': quantity,
    };
  }
}
