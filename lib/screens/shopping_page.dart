
// Core Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/shopping_list_item_model.dart';
import '../providers/shopping_provider.dart';
import '../widgets/add_list.dart';


double textScale = 16;

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  void initState() {
    super.initState();
    // final ShoppingProvider shoppingProvider = context.read<ShoppingProvider>();
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth  =  MediaQuery.sizeOf(context).width;
    final double screenHeight =  MediaQuery.sizeOf(context).height;
    final double screenFontSize  =  MediaQuery.textScalerOf(context).scale(textScale);

    Future<void> _AddListButtonPressed() async {
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => const AddListDialog(title: 'Enter List Name',),
    );

    if (result == null) {
      return;
    }
  }

    return ChangeNotifierProvider(
      create: (_) => ShoppingProvider(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              /// Sorting and top of page options
              const Row(
                children: <Widget>[
                  _SortButton(),
                ],
              ),

              ListSearchBar(screenWidth, screenHeight * .5),
              IconButton.filled(
                constraints: BoxConstraints(
                  maxHeight: screenHeight,
                  maxWidth: screenWidth * .2),
                onPressed: () => _AddListButtonPressed(),
                icon: Icon(Icons.add)),

              SizedBox(height: screenHeight * .02,),

              SingleChildScrollView(
                child: Consumer<ShoppingProvider>(
                  builder: (BuildContext context, ShoppingProvider shoppingLists, Widget? child) {
                    if (shoppingLists.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                
                    if (shoppingLists.lists.isEmpty) {
                      return Center(child: Column(
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            size: screenWidth * .1,
                          ),
                          Text("What's on the next list...",
                            style: TextStyle(fontSize: screenFontSize),)
                        ]
                        )
                      );
                    }
                
                    return shoppingListView(shoppingLists);
                  }
                ),
              )
            ],
          )),
      )
    );
  }

}

Widget ListSearchBar(double width, double height){
  TextEditingController searchText = TextEditingController();
  
  return Row(
    spacing: width * .025,
    children: <Widget>[
      SizedBox(width: width * .01,),
      SearchBar(
        controller: searchText,      
        constraints: BoxConstraints(
          maxWidth: width *.8,
          maxHeight: height * .1,
        ),
        autoFocus: true,
      ),
      
    ]
  );          
}



/// List View of shopping lists
Widget shoppingListView(ShoppingProvider shoppingList){
  return ListView.builder(
    itemCount: shoppingList.items.length,
    itemBuilder: (BuildContext context, int index) {
      final ShoppingListItemModel item = shoppingList.items[index];
      return ListTile(
        title: Text(item.text ?? ''),
      );
    }
  );
}

/// States for sort button
class SortState<T>{
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
class SortButtonState extends State<_SortButton>{
  // Current sort index for list
  int currentIndex = 0;

  // Move to next sort
  void nextState(){
    setState(() {
      // Modulus loops around list
      currentIndex = (currentIndex + 1) % sortingStates.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final SortState<int> currentSort = sortingStates[currentIndex];
    final double screenFontSize  =  MediaQuery.textScalerOf(context).scale(textScale);

    return TextButton(
      onPressed: nextState, // move to next sort
      child: Text(
        'Sort by: ${currentSort.display}',
         style: TextStyle(fontSize: screenFontSize),
      )
    );
  }
}     
