import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ShoppingListItemModel {
  ShoppingListItemModel({
    required this.itemId,
    required this.listId,
    this.productId,
    this.customProductId,
    this.text,
    required this.quantity,
    required this.checked,
    required this.createdAt,
    required this.updatedAt
  });

  factory ShoppingListItemModel.fromJson(Map<String, dynamic> json) {
    debugPrint('.fromJson Started');
    return ShoppingListItemModel(
      itemId: json['item_id'] as int,
      listId: json['list_id'] as int,
      productId: json['product_id'] as int?,
      customProductId: json['custom_product_id'] as int?,
      text: json['text'] as String?,
      quantity: json['quantity'] != null ? json['quantity'] as int : 0,
      checked: json['checked'] as bool,
      createdAt: DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now(),
    );
  }

  final int itemId;
    final int listId;
    final int? productId;
    final int? customProductId;
    final String? text;
    final int quantity;
    final bool checked;
    final DateTime createdAt;
    final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'item_id' : itemId,
      'list_id' : listId,
      'product_id' : productId,
      'custom_product_id' : customProductId,
      'text' : text,
      'quantity' : quantity,
      'checked' : checked,
      'created_at' : createdAt.toIso8601String(),
      'updated_at' : updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'PantryItemModel('
        'itemId: $itemId, '
        'list_id: $listId, '
        'productId: $productId, '
        'customProductId: $customProductId, '
        'text: $text, '
        'quantity: $quantity, '
        'checked: $checked, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }
}
