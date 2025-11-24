import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../models/recipe_details_model.dart';

class RecipeProvider extends ChangeNotifier {

  // Gets the list of metadata for all recipes
  Future<List<RecipeModel>> getAllRecipes() async {
    // Placeholder for fetching recipes logic
    return [];
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