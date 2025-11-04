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
    /// Do not display visible items until search creates changes
    if (searchResults == '') {
      return const SizedBox.shrink();
    }

    /// Show box when no items were found by search
    if (searchResults == 'EMPTY') {
      return Positioned(
        left:  150,
        right: 150,
        top:   460,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 150),
            child: const ListTile(
              title: Text('No Results.'),
            ),
          ),
        ),
      );
    }

    /// Show found items
    return Positioned(
      ///(TODO): Make dimensions dynamic and automatic positioning
      left:  150,
      right: 150,
      top:   460,
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
