import 'package:flutter/material.dart';

/// Positioned Search Result Box 
/// * appears below a CompositedTransformTarget widget that has same Link
/// * Cannot scroll if it escapes bounds of screen/widget
/// * Width and Height can be manually specifed 
/// * if searchResults == 'EMPTY', then no results box is seen
/// * if searchResults == '', then nothing will render
class SearchResultsOverlay extends StatelessWidget {
  const SearchResultsOverlay({
    super.key,
    required this.layerLink,
    required this.searchResults,
    required this.onItemSelected,
    
    this.height = 300, // default
    this.width  = 300, // default
  });

  final dynamic searchResults;
  final dynamic Function(dynamic) onItemSelected;

  // Postition search overlay to provided link
  final LayerLink layerLink;

  // Control size of all boxes
  final double height;
  final double width; 
 
  /// Generate search results
  SizedBox buildSearchItems(dynamic items) {
    return SizedBox(
      height: height,
      width:  width,
      child:  ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(
          color: Colors.grey[300],
          indent: width * .025,
          endIndent: width * .025,
          thickness: 1,
        ),
        shrinkWrap: true,
        itemCount: searchResults['count'] as int,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            hoverColor: Theme.of(context).hoverColor,
            title: Text(searchResults['products'][index]['product_name'] as String),
            onTap: () => onItemSelected(searchResults['products'][index]),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Do not display until search creates changes
    if (searchResults == '') {
      return const SizedBox();
    }

    
    Widget shownResults; // Results to be displayed
    if (searchResults == 'EMPTY') {
      /// Show no items were found
      shownResults =  const ListTile(
        title: Text('No Results')
      );
    } else {
      /// Show found items
      shownResults = buildSearchItems(searchResults);
    }

    /// Show found items
    return CompositedTransformFollower(
      link: layerLink,
      targetAnchor: Alignment.bottomCenter,
      followerAnchor: Alignment.topCenter,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        child: shownResults,
      ),
    );
  }
}
