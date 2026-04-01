import 'dart:convert';

import 'package:uuid/uuid.dart';

class RecipeModel {
  final String id;
  final String recipeName;
  final int timeTaken;
  final String difficulty;
  final String ingredients;
  final String directions;
  final String imageUrl;
  final bool isTodayRecipe;
  final bool isRecommended;
  RecipeModel({
    required this.id,
    required this.recipeName,
    required this.timeTaken,
    required this.difficulty,
    required this.ingredients,
    required this.directions,
    required this.imageUrl,
    this.isTodayRecipe = false,
    this.isRecommended = false,
  });

  static String generateId() => const Uuid().v4();

  RecipeModel copyWith({
    String? id,
    String? recipeName,
    int? timeTaken,
    String? difficulty,
    String? ingredients,
    String? directions,
    String? imageUrl,
    bool? isTodayRecipe,
    bool? isRecommended,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      recipeName: recipeName ?? this.recipeName,
      timeTaken: timeTaken ?? this.timeTaken,
      difficulty: difficulty ?? this.difficulty,
      ingredients: ingredients ?? this.ingredients,
      directions: directions ?? this.directions,
      imageUrl: imageUrl ?? this.imageUrl,
      isTodayRecipe: isTodayRecipe ?? this.isTodayRecipe,
      isRecommended: isRecommended ?? this.isRecommended,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'recipeName': recipeName,
      'timeTaken': timeTaken,
      'difficulty': difficulty,
      'ingredients': ingredients,
      'directions': directions,
      'imageUrl': imageUrl,
      'isTodayRecipe': isTodayRecipe,
      'isRecommended': isRecommended,
    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['id'] as String,
      recipeName: map['recipeName'] as String,
      timeTaken: map['timeTaken'] as int,
      difficulty: map['difficulty'] as String,
      ingredients: map['ingredients'] as String,
      directions: map['directions'] as String,
      imageUrl: map['imageUrl'] as String,
      isTodayRecipe: map['isTodayRecipe'] as bool,
      isRecommended: map['isRecommended'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeModel.fromJson(String source) =>
      RecipeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RecipeModel(id: $id, recipeName: $recipeName, timeTaken: $timeTaken, difficulty: $difficulty, ingredients: $ingredients, directions: $directions, imageUrl: $imageUrl, isTodayRecipe: $isTodayRecipe, isRecommended: $isRecommended)';
  }
}
