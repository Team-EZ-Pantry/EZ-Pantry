










// Core Packages
import 'package:flutter/material.dart';

// Internal Imports
import '../models/shopping_list_model.dart';

class ShoppingListTile extends StatefulWidget {
  ShoppingListTile({
    super.key, 
    required this.shoppingList
  });

  final ShoppingListModel shoppingList;

  @override
  State<ShoppingListTile> createState() => _ShoppingListTileState();
}

class _ShoppingListTileState extends State<ShoppingListTile> {
  @override
  Widget build(BuildContext context) {
    Color listTextColor = Colors.black;
    Color listTileColor = const Color(0xFFACEAAD);
    IconData checkBoxIcon = Icons.check_box_outline_blank; // Initialize checkbox
    
    if (widget.shoppingList.isComplete) {
      listTextColor = Colors.black;
      listTileColor = Colors.brown[100] ?? Colors.grey;
      checkBoxIcon = Icons.check_box_outlined;
    } else {
      checkBoxIcon = Icons.check_box_outline_blank_rounded;
    }

    return ClipRRect(
        child: Padding(
      padding: const EdgeInsetsGeometry.all(3),
      child: ListTile(
        title: Text(widget.shoppingList.name),
        trailing: IconButton(onPressed: () {
          // if not check marked
          if (!widget.shoppingList.isComplete){
            // checkmark
            setState(() {
              widget.shoppingList.isComplete = true;
            });
          } else {
            // uncheckmark
            setState(() {
              widget.shoppingList.isComplete = false;
            });
          }
        }, icon: Icon(checkBoxIcon)),
        tileColor: listTileColor,
        textColor: listTextColor, 
      ),
    ));
  }
}
