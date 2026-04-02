import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:recipia/data/models/recipe_model.dart';

class RecipeRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'recipes';

  final _cloudinary = CloudinaryPublic(
    'djsavcyie',
    'recipia_preset',
    cache: false,
  );

  Future<void> addRecipe(RecipeModel recipe) async {
    try {
      String finalImageUrl = recipe.imageUrl;

      if (recipe.imageUrl.isNotEmpty && !recipe.imageUrl.startsWith('http')) {
        final File fileToUpload = File(recipe.imageUrl);
        if (await fileToUpload.exists()) {
          CloudinaryResponse response = await _cloudinary.uploadFile(
            CloudinaryFile.fromFile(
              fileToUpload.path,
              resourceType: CloudinaryResourceType.Image,
            ),
          );

          finalImageUrl = response.secureUrl;
        }
      }

      final updateRecipe = recipe.copyWith(imageUrl: finalImageUrl);

      await _firestore
          .collection(_collection)
          .doc(updateRecipe.id)
          .set(updateRecipe.toMap());
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

  Future<List<RecipeModel>> searchRecipes(String query) async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();

      return querySnapshot.docs
          .map((doc) => RecipeModel.fromMap(doc.data()))
          .where(
            (recipe) =>
                recipe.recipeName.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } catch (e) {
      throw 'Failed to search recipes: $e';
    }
  }
}
