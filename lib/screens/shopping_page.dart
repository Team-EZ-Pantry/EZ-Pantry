
// Core Packages
import 'package:flutter/material.dart';


class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// Sorting and top of page options
            Row(
              children: <Widget>[
                 SortButton(),
              ],
            ),
            Row(
              children: [
                SizedBox()
              ],)
          ],
        )),
    );
  }

}

/// States for sort button
class SortState<T>{
  SortState({required this.display, required this.value});

  final String display;
  final T value;
}

final List<SortState<int>> sortingStates = [
    SortState<int>(display: 'Name', value: 0),
    SortState<int>(display: 'Created Date', value: 1),
];

class SortButton extends StatefulWidget {
  const SortButton({super.key});

  @override
  SortButtonState createState() => SortButtonState();
}

class SortButtonState extends State<SortButton>{
  int currentIndex = 0;

  void nextState(){
    setState(() {
      // Modulus makes it loop around list
      currentIndex = (currentIndex + 1) % sortingStates.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final SortState<int> currentSort = sortingStates[currentIndex];

    return TextButton(
      onPressed: nextState,
      child: Text('Sort by ${currentSort.display}')
    );
  }
}     
