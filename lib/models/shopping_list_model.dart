import 'package:flutter/foundation.dart';

class ShoppingListModel {
  ShoppingListModel({
    required this.id,
    required this.text,
  });

  factory ShoppingListModel.fromJson(Map<String, dynamic> json) {
    debugPrint('.fromJson Started');
    return ShoppingListModel(
      id: json['id'] as int,
      text: json['text'] as String,
    );
  }

  final int id;
  final String text;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'text': text,
    };
  }

  @override
  String toString() {
    return 'PantryItemModel('
        'id: $id, '
        'text: $text, '
        ')';
  }
}