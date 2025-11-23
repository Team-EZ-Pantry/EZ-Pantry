class RecipeModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int prepTime;
  final int cookTime;
  final int servings;

  RecipeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      prepTime: json['prepTime'] as int,
      cookTime: json['cookTime'] as int,
      servings: json['servings'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
    };
  }

  RecipeModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? prepTime,
    int? cookTime,
    int? servings,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
    );
  }
}