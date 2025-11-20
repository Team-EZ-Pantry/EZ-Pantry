import 'package:flutter/material.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final List<String> recipes = List.generate(10, (i) => 'Recipe ${i + 1}');
  late List<String> filteredRecipes;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredRecipes = recipes;
    _searchController.addListener(_filterRecipes);
  }

  void _filterRecipes() {
    setState(() {
      filteredRecipes = recipes
          .where((recipe) =>
              recipe.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredRecipes.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: const Icon(Icons.add_circle, color: Colors.green),
                      title: const Text('Add New Recipe'),
                      subtitle: const Text('Create a custom recipe'),
                      //trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // TODO: Navigate to add recipe page
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Add recipe functionality coming soon!')),
                        );
                      },
                    ),
                  );
                }
                return RecipeTile(
                  recipeIndex: int.parse(filteredRecipes[index - 1].split(' ')[1]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(
                            recipeIndex:
                                int.parse(filteredRecipes[index - 1].split(' ')[1])),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeTile extends StatelessWidget {
  final int recipeIndex;
  final VoidCallback onTap;

  const RecipeTile({
    required this.recipeIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('Recipe $recipeIndex'),
        subtitle: const Text('Tap to view details'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}

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
