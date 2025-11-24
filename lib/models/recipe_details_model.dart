class RecipeDetailsModel {

  RecipeDetailsModel({
    required this.id,
    required this.ingredients,
    required this.instructions,
  });

  final String id;
  final List<String> ingredients;
  final List<String> instructions;

  factory RecipeDetailsModel.fromJson(Map<String, dynamic> json) {
    return RecipeDetailsModel(
      id: json['id'] as String,
      ingredients: List<String>.from(json['ingredients'] as List<String>),
      instructions: List<String>.from(json['instructions'] as List<String>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ingredients': ingredients,
      'instructions': instructions,
    };
  }

  RecipeDetailsModel copyWith({
    String? id,
    List<String>? ingredients,
    List<String>? instructions,
  }) {
    return RecipeDetailsModel(
      id: id ?? this.id,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
    );
  }
}
