import 'package:flutter/foundation.dart';

class ShoppingListModel {
  ShoppingListModel({
    required this.listId,
    required this.userId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.isComplete
  });

  factory ShoppingListModel.fromJson(Map<String, dynamic> json) {
    debugPrint('.fromJson Started');
    return ShoppingListModel(
      listId: json['list_id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String,
      createdAt: DateTime.tryParse(json['created_at'].toString())!,
      updatedAt: DateTime.tryParse(json['updated_at'].toString())!,
      isComplete: json['is_complete'] as bool
    );
  }

  final int listId;
  final int userId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
        bool isComplete;    // Completion should be changeable


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'list_id': listId,
      'user_id': userId,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_complete': isComplete
    };
  }

  @override
  String toString() {
    return 'ShoppingListModel('
        'list_id: $listId, '
        'user_id: $userId, '
        'name: $name, '
        'created_at: $createdAt, '
        'updated_at: $updatedAt, '
        'is_complete: $isComplete, '
        ')';
  }
}