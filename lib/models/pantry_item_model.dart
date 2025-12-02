import 'package:flutter/foundation.dart';

class PantryItemModel {
  PantryItemModel({
    required this.id,
    required this.productType,
    required this.name,
    this.brand = '',
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
  debugPrint('.fromJson Started');
  return PantryItemModel(
    id: json['id'] as int,
    productType: json['product_type'] as String? ?? '',
    name: json['product_name'] as String? ?? '',
    brand: json['brand'] as String? ?? '',
    quantity: json['quantity'] != null ? json['quantity'] as int : 0,
    expirationDate: json['expiration_date']?.toString(),
    imageUrl: json['image_url']?.toString(),
    calories: json['calories_per_100g'] != null ? json['calories_per_100g'].toString() : '',
    protein: json['protein_per_100g']?.toString() ?? '',
    carbs: json['carbs_per_100g']?.toString() ?? '',
    fat: json['fat_per_100g']?.toString() ?? '',
    nutritionFacts: json['nutrition'] as Map<String, dynamic>? ?? <String, dynamic>{},
    createdAt: DateTime.tryParse(json['added_at']?.toString() ?? json['created_at']?.toString() ?? '') ?? DateTime.now(),
  );
}

  final int id;
  final String productType;
  final String name;
  final String? brand;
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
      'id': id,
      'product_type': productType,
      'product_name': name,
      'brand': brand,
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
        'productType: $productType'
        'name: $name, '
        'brand: $brand, '
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