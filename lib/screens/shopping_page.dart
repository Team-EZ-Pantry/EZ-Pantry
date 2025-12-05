// Core Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/shopping_list_item_model.dart';
import '../models/shopping_list_model.dart';
import '../providers/shopping_provider.dart';
import '../widgets/add_list.dart';
import '../widgets/shopping_list_view.dart';
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
    searchText = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;   // Get device's max width
    final double screenHeight = MediaQuery.sizeOf(context).height; // Get device's max height

    Future<void> addListButtonPressed() async {
      final String? result = await showDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            AddListDialog(title: 'Enter List Name', listName: searchText.text),
      );
      
      if (result == null) {
        return;
      }
    }

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
                children: <Widget>[
                  SizedBox(width: screenWidth * .01),
                  SearchBar(
                    controller: searchText,
                    constraints: BoxConstraints(
                      maxWidth: screenWidth * .8,
                      maxHeight: screenHeight * .1,
                    ),
                  ),
                  SizedBox(width: screenWidth * .01),
                  IconButton.filled(
                    constraints: BoxConstraints(
                      maxHeight: screenHeight,
                      maxWidth: screenWidth * .2,
                    ),
                    onPressed: () => addListButtonPressed(),
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * .02),

              Column( children: <Widget>[
                shoppingListView(screenHeight * .4, screenWidth),
              ],),
              
            ],
          ),
        ),
      ),
    );
  }
}

/// View of shopping lists
Widget shoppingListView(double maxHeight, double maxWidth) {
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
        return Center(
          child: Column(
            children: <Widget>[
              Icon(Icons.remove_shopping_cart_outlined, size: maxWidth * .1),
              const Text("What's on the next list..."),
            ],
          ),
        );
      }

      // View of shopping lists
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: ListView.builder(
          clipBehavior: Clip.antiAlias,
          itemCount: shoppingLists.lists.length,
          itemBuilder: (BuildContext context, int index) {
            final ShoppingListModel list = shoppingLists.lists[index];          
            return ShoppingListTile(shoppingList: list);
          },
        ),
      );
    }
  );
}
