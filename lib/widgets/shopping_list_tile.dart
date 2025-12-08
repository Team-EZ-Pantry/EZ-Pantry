// Core Packages
import 'package:flutter/material.dart';

// Internal Imports
import '../models/shopping_list_model.dart';

class ShoppingListTile extends StatefulWidget {
  ShoppingListTile({super.key, required this.shoppingList});

  final ShoppingListModel shoppingList;

  @override
  State<ShoppingListTile> createState() => _ShoppingListTileState();
}

class _ShoppingListTileState extends State<ShoppingListTile> {
  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme; // Get current colors of app
    Color listTextColor;                               // Text color on tile
    Color listTileColor;                               // Tackground tile color
    IconData checkBoxIcon;

    // Change looks depending on list completion
    if (widget.shoppingList.isComplete) {
      // List is completed
      listTextColor = themeColors.onSecondaryContainer;
      listTileColor = themeColors.secondaryContainer; 
      checkBoxIcon = Icons.check_box_outlined; // checkmarked box
    } else {
      // List is not completed
      listTextColor = themeColors.onPrimaryContainer;                 
      listTileColor = themeColors.primaryContainer;       
      checkBoxIcon = Icons.check_box_outline_blank_rounded; // empty square box
    }

    return ClipRRect(
      child: Padding(
        padding: const EdgeInsetsGeometry.all(3),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
          title: Text(widget.shoppingList.name),
          trailing: IconButton(
            // Toggle list completion
            onPressed: () {
              if (widget.shoppingList.isComplete) {
                // uncheckmark
                setState(() {
                  widget.shoppingList.isComplete = false;
                });
              } else {
                // checkmark
                setState(() {
                  widget.shoppingList.isComplete = true;
                });
              }
            },
            icon: Icon(checkBoxIcon),
          ),
          tileColor: listTileColor,
          textColor: listTextColor,
        ),
      ),
    );
  }
}
