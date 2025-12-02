import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '/../screens/recipe_detail_page.dart';
import '/../providers/recipe_provider.dart';
import 'package:provider/provider.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  List<RecipeModel> allRecipes = [];
  List<RecipeModel> filteredRecipes = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterRecipes);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecipes();
    });
  }

  Future<void> _loadRecipes() async {
    final RecipeProvider recipeProvider = context.read<RecipeProvider>();
    final recipes = await recipeProvider.getAllRecipes();
    setState(() {
      allRecipes = recipes;
      filteredRecipes = recipes;
      isLoading = false;
    });
  }

  void _filterRecipes() {
    setState(() {
      filteredRecipes = allRecipes
          .where((recipe) =>
              recipe.name.toLowerCase().contains(_searchController.text.toLowerCase()))
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: filteredRecipes.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: const Icon(Icons.add_circle, color: Colors.green),
                            title: const Text('Add New Recipe'),
                            subtitle: const Text('Create a custom recipe'),
                            onTap: () {
                              // TODO: Navigate to add recipe page
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Add recipe functionality coming soon!')),
                              );
                            },
                          ),
                        );
                      }
                      final RecipeModel recipe = filteredRecipes[index - 1];
                      return RecipeTile(
                        recipe: recipe,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) => RecipeDetailPage(
                                  recipeIndex: int.parse(recipe.id)),
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
  final RecipeModel recipe;
  final VoidCallback onTap;

  const RecipeTile({
    required this.recipe,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: recipe.imageUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  recipe.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.restaurant, size: 40),
                ),
              )
            : const Icon(Icons.restaurant, size: 40),
        title: Text(recipe.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${recipe.prepTime + recipe.cookTime} min • ${recipe.servings} servings',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}