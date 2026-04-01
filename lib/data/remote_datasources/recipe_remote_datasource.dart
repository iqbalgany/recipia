import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipia/data/models/recipe_model.dart';

class RecipeRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'recipes';

  Future<void> addRecipe(RecipeModel recipe) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(recipe.id)
          .set(recipe.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RecipeModel>> getAllRecipes() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();

      return querySnapshot.docs
          .map((doc) => RecipeModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw 'Failed to retrieve recipe data: $e';
    }
  }

  Future<RecipeModel> getRecipeById(String id) async {
    try {
      final docSnapshot = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      if (docSnapshot.exists) {
        return RecipeModel.fromMap(docSnapshot.data()!);
      } else {
        throw 'Recipe not found';
      }
    } catch (e) {
      throw 'Failed to retrieve recipe details: $e';
    }
  }

  Future<List<RecipeModel>> getTodayRecipes() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('isTodayRecipe', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => RecipeModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw 'Failed to retrieve today\'s recipes: $e';
    }
  }

  Future<List<RecipeModel>> getRecommendedRecipes() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('isRecommended', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => RecipeModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw 'Failed to retrieve recommended recipes: $e';
    }
  }
}
