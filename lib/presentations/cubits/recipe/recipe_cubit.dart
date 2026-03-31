import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recipia/data/models/recipe_model.dart';
import 'package:recipia/data/remote_datasources/recipe_remote_datasource.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final RecipeRemoteDatasource _datasource;
  RecipeCubit(this._datasource) : super(const RecipeState());

  Future<void> fetchAllRecipes() async {
    emit(state.copyWith(status: RecipeStatus.loading));
    try {
      final recipes = await _datasource.getAllRecipes();

      emit(state.copyWith(recipes: recipes, status: RecipeStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: RecipeStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> fetchRecipeById(String id) async {
    emit(state.copyWith(status: RecipeStatus.loading));
    try {
      final recipe = await _datasource.getRecipeById(id);
      emit(
        state.copyWith(status: RecipeStatus.success, selectedRecipe: recipe),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RecipeStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addNewRecipe(RecipeModel recipe) async {
    emit(state.copyWith(status: RecipeStatus.loading));
    try {
      await _datasource.addRecipe(recipe);

      await fetchAllRecipes();
    } catch (e) {
      emit(
        state.copyWith(
          status: RecipeStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
