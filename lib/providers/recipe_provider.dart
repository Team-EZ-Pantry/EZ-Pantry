import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../models/recipe_details_model.dart';

class RecipeProvider extends ChangeNotifier {
  List<RecipeModel> _recipes = <RecipeModel>[];
  List<RecipeModel> get recipes => _recipes;

  void init() {
      // schedule after first frame to avoid calling notifyListeners during build
      Future.microtask(() => getAllRecipes());
    }
  // Gets the list of metadata for all recipes
  Future<List<RecipeModel>> getAllRecipes() async {
    // Sample data for testing
    return [
      RecipeModel(
        id: '1',
        name: 'Spaghetti Carbonara',
        description: 'Classic Italian pasta dish with eggs, cheese, and bacon',
        imageUrl: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=400',
        prepTime: 10,
        cookTime: 20,
        servings: 4,
      ),
      RecipeModel(
        id: '2',
        name: 'Chicken Tikka Masala',
        description: 'Creamy and spicy Indian curry with tender chicken pieces',
        imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400',
        prepTime: 20,
        cookTime: 30,
        servings: 6,
      ),
      RecipeModel(
        id: '3',
        name: 'Caesar Salad',
        description: 'Fresh romaine lettuce with parmesan cheese and croutons',
        imageUrl: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
        prepTime: 15,
        cookTime: 0,
        servings: 2,
      ),
      RecipeModel(
        id: '4',
        name: 'Beef Tacos',
        description: 'Seasoned ground beef in crispy shells with fresh toppings',
        imageUrl: 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400',
        prepTime: 10,
        cookTime: 15,
        servings: 4,
      ),
      RecipeModel(
        id: '5',
        name: 'Chocolate Chip Cookies',
        description: 'Soft and chewy cookies loaded with chocolate chips',
        imageUrl: 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=400',
        prepTime: 15,
        cookTime: 12,
        servings: 24,
      ),
      RecipeModel(
        id: '6',
        name: 'Greek Gyros',
        description: 'Pita wraps filled with seasoned meat and tzatziki sauce',
        imageUrl: 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=400',
        prepTime: 20,
        cookTime: 25,
        servings: 4,
      ),
      RecipeModel(
        id: '7',
        name: 'Vegetable Stir Fry',
        description: 'Quick and healthy mix of colorful vegetables in savory sauce',
        imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400',
        prepTime: 10,
        cookTime: 10,
        servings: 3,
      ),
      RecipeModel(
        id: '8',
        name: 'Margherita Pizza',
        description: 'Simple and delicious pizza with tomato, mozzarella, and basil',
        imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
        prepTime: 30,
        cookTime: 15,
        servings: 4,
      ),
    ];
  }
  
  Future<RecipeDetailsModel> getRecipeDetails(int recipeId) async {
    // Placeholder for fetching recipe details logic
    return RecipeDetailsModel(id: '', ingredients: [], instructions: []);
  }

  Future<List<String>> editIngredients(int recipeId, List<String> newIngredients) async {
    // Placeholder for editing ingredients logic
    return [];
  }

  Future<List<String>> editInstructions(int recipeId, List<String> newInstructions) async {
    // Placeholder for editing instructions logic
    return [];
  }

  Future<bool> deleteRecipe(int recipeId) async {
    // Placeholder for deleting recipe logic
    return true;
  }


}