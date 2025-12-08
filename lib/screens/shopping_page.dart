// Core Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Internal Imports
import '../models/shopping_list_model.dart';
import '../providers/shopping_provider.dart';
import '../widgets/add_list.dart';
import '../widgets/shopping_list_tile.dart';
import '../widgets/sort_button.dart';

double textScale = 16;
TextEditingController searchText = TextEditingController();

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  void initState() {
    super.initState();
    searchText = TextEditingController(); // reset text state
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth  = MediaQuery.sizeOf(context).width;  // Get device's max width
    final double screenHeight = MediaQuery.sizeOf(context).height; // Get device's max height

    final ColorScheme colorScheme = Theme.of(context).colorScheme; // Get app's color scheme 

    /// Create dialog to add list
    Future<void> addListButtonPressed() async {
      final String? result = await showDialog<String>(
        context: context,
        builder: (BuildContext context) =>
          AddListDialog(title: 'Enter List Name'),
      );

      // Leave after dialog is closed
      if (result == null) {
        return;
      }
    }

    // Local provider is contained within this scope
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        final ShoppingProvider shoppingProvider = ShoppingProvider();
        shoppingProvider.loadShoppingLists();
        return shoppingProvider;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              /// Sorting and top of page options
              const Row(children: <Widget>[SortButton()]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SearchBar(
                    controller: searchText,
                    constraints: BoxConstraints(maxWidth: screenWidth * .80),
                    hintText: "WIP"
                  ),
                  SizedBox(width: screenWidth * .02),
                  // Add List button
                  // TODO: Ask user to add new list based on text that is entered in search bar
                  IconButton.filled(
                    color: colorScheme.primary,
                    constraints: BoxConstraints(
                      maxHeight: screenHeight,
                      maxWidth: screenWidth * .2,
                    ),
                    onPressed: () => addListButtonPressed(),
                    icon: Icon(
                      Icons.add_shopping_cart_rounded,
                      color: colorScheme.onPrimary),
                  ),
                ],
              ),

              // Spacing between
              SizedBox(height: screenHeight * .02),

              // Expanded keeps scroll view contained within screen bounds
              // Necessary to stop scroll view from not actually appearing on screen
              Expanded(
                child: shoppingListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// View of shopping lists
Widget shoppingListView() {
  /// Gets lists from provider
  return Consumer<ShoppingProvider>(
    builder: (BuildContext context, ShoppingProvider shoppingLists, Widget? child) {
      debugPrint('Shopping Lists:${shoppingLists.lists.length}');
      // Show while loading
      if (shoppingLists.loading) {
        return const Center(child: CircularProgressIndicator());
      }

      // Show if empty
      if (shoppingLists.lists.isEmpty) {
        return const Center(
          child: Column(
            children: <Widget>[
              Icon(Icons.remove_shopping_cart_outlined),
              Text("What's on the next list..."),
            ],
          ),
        );
      }

      // View of shopping lists
      return Material(
        child: ListView.builder(
          itemCount: shoppingLists.lists.length,
          itemBuilder: (BuildContext context, int index) {
            final ShoppingListModel list = shoppingLists.lists[index];
            return ShoppingListTile(shoppingList: list);
          },
        ),
      );
    },
  );
}
