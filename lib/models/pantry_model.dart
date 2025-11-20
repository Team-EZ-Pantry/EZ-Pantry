import 'package:flutter/foundation.dart';

class PantryModel {
  PantryModel({
    required this.pantryId,
    required this.userId,
    required this.name,
    required this.isDefault,
    required this.createdAt,
  });

  factory PantryModel.fromJson(Map<String, dynamic> json) {
    return PantryModel(
      pantryId: json['pantry_id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String,
      isDefault: json['is_default'] as bool,
      createdAt: json['created_at'] as DateTime,
    );
  }

  final int pantryId;
  final int userId;
  final String name;
  final bool isDefault;
  final DateTime createdAt;


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pantry_id': pantryId,
      'user_id': userId,
      'name': name,
      'is_default': isDefault,
      'created_at': createdAt,
    };
  }

  @override
  String toString() {
    return 'PantryItemModel('
        'pantry_id: $pantryId, '
        'user_id: $userId, '
        'name: $name, '
        'is_default: $isDefault, '
        'created_at: $createdAt, '
        ')';
  }
}