import 'package:flutter/material.dart';

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
class SortButton extends StatefulWidget {
  const SortButton({super.key});

  @override
  SortButtonState createState() => SortButtonState();
}

// Actual widget and methods
// * Where state variables can be found
class SortButtonState extends State<SortButton> {
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
    final double screenFontSize = MediaQuery.textScalerOf(context).scale(16);

    return TextButton(
      onPressed: nextState, // move to next sort
      child: Text('Sort by: ${currentSort.display}', style: TextStyle(fontSize: screenFontSize)),
    );
  }
}
