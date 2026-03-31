// ignore_for_file: public_member_api_docs, sort_constructors_first

class RecipeModel {
  final String id;
  final String recipeName;
  final int timeTaken;
  final String ingredients;
  final String directions;
  RecipeModel({
    required this.id,
    required this.recipeName,
    required this.timeTaken,
    required this.ingredients,
    required this.directions,
  });

  RecipeModel copyWith({
    String? id,
    String? recipeName,
    int? timeTaken,
    String? ingredients,
    String? directions,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      recipeName: recipeName ?? this.recipeName,
      timeTaken: timeTaken ?? this.timeTaken,
      ingredients: ingredients ?? this.ingredients,
      directions: directions ?? this.directions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'recipeName': recipeName,
      'timeTaken': timeTaken,
      'ingredients': ingredients,
      'directions': directions,
    };
  }

  factory RecipeModel.fromMap(String id, Map<String, dynamic> map) {
    return RecipeModel(
      id: id,
      recipeName: map['recipeName'] as String,
      timeTaken: map['timeTaken'] as int,
      ingredients: map['ingredients'] as String,
      directions: map['directions'] as String,
    );
  }
}
