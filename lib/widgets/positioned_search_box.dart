import 'package:flutter/material.dart';

/// Positioned Search Result Box
class SearchResultsOverlay extends StatelessWidget {
  const SearchResultsOverlay({
    super.key,
    required this.searchResults,
    required this.onItemSelected,
  });

  final dynamic searchResults;
  final Function(String) onItemSelected;

  @override
  Widget build(BuildContext context) {
    /// Do not display visible items if no results
    if (searchResults == '') {
      return const SizedBox.shrink();
    }

    return Positioned(
      ///(TODO): Make dimensions dynamic and automatic positioning
      left:  150,
      right: 150,
      top:   350,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 150),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: searchResults['count'] as int,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(searchResults['products'][index]['product_name'] as String),
                onTap: () => onItemSelected(searchResults['products'][index]['product_id'].toString()),
                ///(TODO): Create new model for search items to avoid dynamic calls.
              );
            },
          ),
        ),
      ),
    );
  }
}
