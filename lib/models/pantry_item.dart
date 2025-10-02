class PantryItemModel {
  final int id;
  final String title;
  final int quantity;

  PantryItemModel({
    required this.id,
    required this.title,
    required this.quantity,
  });

  // Create a PantryItem from JSON
  factory PantryItemModel.fromJson(Map<String, dynamic> json) {
    return PantryItemModel(
      id: json['id'],
      title: json['title'],
      quantity: json['quantity'],
    );
  }

  // Convert PantryItem to JSON (useful for POST requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
    };
  }
}
