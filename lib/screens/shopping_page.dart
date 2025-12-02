// Core Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/shopping_list_item_model.dart';
import '../models/shopping_list_model.dart';
import '../providers/shopping_provider.dart';
import '../services/shopping_service.dart';
import '../widgets/add_list.dart';

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
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenFontSize = MediaQuery.textScalerOf(context).scale(textScale);

    Future<void> _AddListButtonPressed() async {
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
            children: [
              /// Sorting and top of page options
              const Row(children: <Widget>[_SortButton()]),

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
                    onPressed: () => _AddListButtonPressed(),
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * .02),
              Consumer<ShoppingProvider>(
                builder: (BuildContext context, ShoppingProvider shoppingLists, Widget? child) {
                  if (shoppingLists.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (shoppingLists.lists.isEmpty) {
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.shopping_cart, size: screenWidth * .1),
                          Text(
                            "What's on the next list...",
                            style: TextStyle(fontSize: screenFontSize),
                          ),
                        ],
                      ),
                    );
                  }

                  return shoppingListView(shoppingLists, screenHeight * .2);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// List View of shopping lists
Widget shoppingListView(ShoppingProvider shoppingLists, double maxHeight) {
  debugPrint('Shopping Lists:${shoppingLists.lists.length}');
  return ConstrainedBox(
    constraints: BoxConstraints(maxHeight: maxHeight),
    child: ListView.builder(
      itemCount: shoppingLists.lists.length,
      itemBuilder: (BuildContext context, int index) {
        final ShoppingListModel list = shoppingLists.lists[index];
        var listTextColor = Theme.of(context).primaryColorLight;
        var listTileColor = Theme.of(context).primaryColorDark;
        if (list.isComplete) {
          listTextColor = Theme.of(context).shadowColor;
          listTileColor = Theme.of(context).shadowColor;
        }
        return ListTile(
          title: Text(list.name),
          tileColor: listTileColor,
          textColor: listTextColor, 
          );
      },
    ),
  );
}

/// States for sort button
class SortState<T> {
  SortState({required this.display, required this.value});

  final String display;
  final T value;
}

// List of available sorting methods
final List<SortState<int>> sortingStates = [
  SortState<int>(display: 'Name', value: 0),
  SortState<int>(display: 'Created Date', value: 1),
];

// Generate sort button
class _SortButton extends StatefulWidget {
  const _SortButton({super.key});

  @override
  SortButtonState createState() => SortButtonState();
}

// Actual widget and methods
// * Where state variables can be found
class SortButtonState extends State<_SortButton> {
  // Current sort index for list
  int currentIndex = 0;

  // Move to next sort
  void nextState() {
    setState(() {
      // Modulus loops around list
      currentIndex = (currentIndex + 1) % sortingStates.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final SortState<int> currentSort = sortingStates[currentIndex];
    final double screenFontSize = MediaQuery.textScalerOf(context).scale(textScale);

    return TextButton(
      onPressed: nextState, // move to next sort
      child: Text('Sort by: ${currentSort.display}', style: TextStyle(fontSize: screenFontSize)),
    );
  }
}
