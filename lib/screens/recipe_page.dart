import 'package:flutter/material.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: 10, // Replace with actual data length
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Recipe ${index + 1}'),
              );
            },
          ),
        ],
      ),
    );
  }
}
