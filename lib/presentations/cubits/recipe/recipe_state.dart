// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'recipe_cubit.dart';

enum RecipeStatus { initial, loading, success, failure }

class RecipeState extends Equatable {
  final List<RecipeModel> recipes;
  final List<RecipeModel> todayRecipes;
  final List<RecipeModel> recommendedRecipes;
  final RecipeModel? selectedRecipe;
  final RecipeStatus status;
  final String errorMessage;
  const RecipeState({
    this.recipes = const [],
    this.todayRecipes = const [],
    this.recommendedRecipes = const [],
    this.selectedRecipe,
    this.status = RecipeStatus.initial,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [
    status,
    selectedRecipe,
    recipes,
    todayRecipes,
    recommendedRecipes,
    errorMessage,
  ];

  RecipeState copyWith({
    List<RecipeModel>? recipes,
    List<RecipeModel>? todayRecipes,
    List<RecipeModel>? recommendedRecipes,
    RecipeModel? selectedRecipe,
    RecipeStatus? status,
    String? errorMessage,
  }) {
    return RecipeState(
      recipes: recipes ?? this.recipes,
      todayRecipes: todayRecipes ?? this.todayRecipes,
      recommendedRecipes: recommendedRecipes ?? this.recommendedRecipes,
      selectedRecipe: selectedRecipe ?? this.selectedRecipe,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
