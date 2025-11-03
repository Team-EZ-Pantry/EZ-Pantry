class PantryItemModel {
  PantryItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    this.expirationDate,
    this.imageUrl,
    this.calories = '',
    this.protein = '',
    this.carbs = '',
    this.fat = '',
    required this.nutritionFacts,
    required this.createdAt,
  });

  factory PantryItemModel.fromJson(Map<String, dynamic> json) {
    return PantryItemModel(
      id: json['product_id'] as int,
      name: json['product_name'] as String,
      quantity: json['quantity'] != null ? json['quantity'] as int : 0,
      expirationDate: json['expiration_date']?.toString(),
      imageUrl: json['image_url']?.toString(),
      calories: json['calories_per_100g']?.toString() ?? '',
      protein: json['protein_per_100g']?.toString() ?? '',
      carbs: json['carbs_per_100g']?.toString() ?? '',
      fat: json['fat_per_100g']?.toString() ?? '',
      nutritionFacts: json['nutrition'] as Map<String, dynamic>? ?? <String, dynamic>{},
      createdAt: DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now(),
    );
  }

  final int id;
  final String name;
  int quantity;
  final String? expirationDate;
  final String? imageUrl;
  final String calories;
  final String protein;
  final String carbs;
  final String fat;
  Map<String, dynamic> nutritionFacts;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'product_id': id,
      'product_name': name,
      'quantity': quantity,
      'expiration_date': expirationDate,
      'image_url': imageUrl,
      'calories_per_100g': calories,
      'protein_per_100g': protein,
      'carbs_per_100g': carbs,
      'fat_per_100g': fat,
      'nutrition': nutritionFacts,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'PantryItemModel('
        'id: $id, '
        'name: $name, '
        'quantity: $quantity, '
        'expirationDate: $expirationDate, '
        'imageUrl: $imageUrl, '
        'calories: $calories, '
        'protein: $protein, '
        'carbs: $carbs, '
        'fat: $fat, '
        'nutritionFacts: $nutritionFacts, '
        'createdAt: $createdAt'
        ')';
  }
}
