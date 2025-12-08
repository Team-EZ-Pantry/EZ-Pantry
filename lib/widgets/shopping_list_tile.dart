// Core Packages
import 'package:flutter/material.dart';

// Internal Imports
import '../models/pantry_item_model.dart';
import '../models/shopping_list_item_model.dart';
import '../models/shopping_list_model.dart';
import 'pantry_item.dart';

/// States for each list
class ListState<T> {
  ListState({required this.display, required this.value});

  final String display;
  final T value;
}

// List of available sorting methods
final List<ListState<bool>> listStates = [
  ListState<bool>(display: 'Collapsed', value: false),
  ListState<bool>(display: 'Expanded', value: true),
];

class ShoppingListTile extends StatefulWidget {
  ShoppingListTile({
    super.key, 
    required this.shoppingList,
    required this.shoppingItems
  });

  final ShoppingListModel shoppingList;
  final List<ShoppingListItemModel> shoppingItems;

  @override
  State<ShoppingListTile> createState() => _ShoppingListTileState();
}

class _ShoppingListTileState extends State<ShoppingListTile> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme themeColors = Theme.of(context).colorScheme; // Get current colors of app

    Color listTextColor;                               // Text color on tile
    Color listTileColor;                               // Tackground tile color

    IconData checkBoxIcon;
    IconData listExpanseIcon = Icons.chevron_right;    // Show whether list is collapsed are expanded

    int currentStateIndex = 0; // local starting list state

    final ListState<bool> currentListState = listStates[currentStateIndex]; // a state from the list 

    // Move to next state
    void toggleExpansion() {
      setState(() {
        // Loops around list
        debugPrint('List Expansion toggled.');
        currentStateIndex = (currentStateIndex + 1) % listStates.length;
      });
    }

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

    // If list is NOT expanded
    if (currentListState.value == false) {
      return Padding(
          padding: const EdgeInsetsGeometry.all(4),
          child: ListTile(
            leading: IconButton(
              icon: Icon(listExpanseIcon),
              onPressed: () {
                toggleExpansion();
              },
              ),
            onTap: () {
              
            },
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
      );
    } else {
      debugPrint('Trying to show expanded list');
      return ListView.builder(
        itemCount: widget.shoppingItems.length,
        itemBuilder: (BuildContext context, int index) {
          return PantryItemTile(
            item: widget.shoppingItems[index] as PantryItemModel, 
            onTap: () {  },
            incrementQuantity: () {  },
            decrementQuantity: () {  },
            changeQuantity: (int value) {  },
          );
      },);
    }
  }
}
