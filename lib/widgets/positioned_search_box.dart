import 'package:flutter/material.dart';

        class SearchResultsOverlay extends StatelessWidget {
          const SearchResultsOverlay({
            Key? key,
            required this.searchResults,
            required this.onItemSelected,
          }) : super(key: key);

          final dynamic searchResults;
          final Function(String) onItemSelected;

          @override
          Widget build(BuildContext context) {
            if (searchResults == '') return const SizedBox.shrink();

            return Positioned(
              left: 50,
              right: 50,
              top: 350,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 150),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchResults['count'] as int,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(searchResults['products'][index]['product_name'] as String),
                        onTap: () => onItemSelected(searchResults['products'][index]['product_id'].toString()),
                      );
                    },
                  ),
                ),
              ),
            );
          }
        }