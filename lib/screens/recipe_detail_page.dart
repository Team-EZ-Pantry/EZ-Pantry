import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  final int recipeIndex;

  const RecipeDetailPage({required this.recipeIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe $recipeIndex')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Ingredient 1\n• Ingredient 2\n• Ingredient 3'),
            const SizedBox(height: 24),
            const Text(
              'Instructions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('1. Step 1\n2. Step 2\n3. Step 3'),
          ],
        ),
      ),
    );
  }
}
