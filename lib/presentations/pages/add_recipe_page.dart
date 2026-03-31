import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipia/data/models/recipe_model.dart';
import 'package:recipia/presentations/cubits/recipe/recipe_cubit.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _recipeNameController = TextEditingController();
  final _timeTakenController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _directionsController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipeCubit, RecipeState>(
      listener: (context, recipeState) {
        if (recipeState.status == RecipeStatus.success) {
          _recipeNameController.clear();
          _timeTakenController.clear();
          _ingredientsController.clear();
          _directionsController.clear();
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Add Recipe',
            style: GoogleFonts.fredoka(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            style: ButtonStyle(
              side: WidgetStatePropertyAll(BorderSide(color: Colors.black)),
            ),
            icon: Icon(Icons.arrow_back_rounded),
          ),
        ),
        body: BlocBuilder<RecipeCubit, RecipeState>(
          builder: (context, recipeState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe Name
                      Text(
                        'Recipe Name',
                        style: GoogleFonts.fredoka(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      TextFormField(
                        controller: _recipeNameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blue.shade100,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter Recipe Name',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Time Taken
                      Text(
                        'Time Taken',
                        style: GoogleFonts.fredoka(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      TextFormField(
                        controller: _timeTakenController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blue.shade100,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter Time (Minute)',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Ingredients
                      Text(
                        'Ingredients',
                        style: GoogleFonts.fredoka(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      TextFormField(
                        maxLines: 5,
                        controller: _ingredientsController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blue.shade100,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter Ingredients',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Directions
                      Text(
                        'Directions',
                        style: GoogleFonts.fredoka(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      TextFormField(
                        maxLines: 5,
                        controller: _directionsController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blue.shade100,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter Directions',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),

                      // Submit Button
                      if (recipeState.status == RecipeStatus.loading)
                        Center(child: CircularProgressIndicator())
                      else
                        Center(
                          child: TextButton(
                            onPressed: () {
                              context.read<RecipeCubit>().addNewRecipe(
                                RecipeModel(
                                  id: '',
                                  recipeName: _recipeNameController.text.trim(),
                                  timeTaken: int.parse(
                                    _timeTakenController.text.trim(),
                                  ),
                                  ingredients: _ingredientsController.text
                                      .trim(),
                                  directions: _directionsController.text.trim(),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              fixedSize: WidgetStatePropertyAll(
                                Size(MediaQuery.sizeOf(context).width, 50),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                Colors.green,
                              ),
                            ),
                            child: Text(
                              'Add Recipe',
                              style: GoogleFonts.fredoka(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
