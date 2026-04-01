import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipia/data/models/recipe_model.dart';
import 'package:recipia/presentations/cubits/recipe/recipe_cubit.dart';

class DetailRecipePage extends StatefulWidget {
  final String recipeId;
  const DetailRecipePage({super.key, required this.recipeId});

  @override
  State<DetailRecipePage> createState() => _DetailRecipePageState();
}

class _DetailRecipePageState extends State<DetailRecipePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RecipeCubit, RecipeState>(
        builder: (context, state) {
          final recipe = state.recipes.firstWhere(
            (e) => e.id == widget.recipeId,
            orElse: () => RecipeModel(
              id: '',
              recipeName: 'Recipe not found',
              difficulty: '',
              imageUrl: '',
              isRecommended: false,
              isTodayRecipe: false,
              timeTaken: 0,
              ingredients: '',
              directions: '',
            ),
          );

          if (recipe.id.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('Recipe not found')),
            );
          }

          return SingleChildScrollView(
            child: Stack(
              children: [
                Image.file(
                  File(recipe.imageUrl),
                  fit: BoxFit.cover,
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height / 2,
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height / 2.3,
                  ),
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(60),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.recipeName,
                        style: GoogleFonts.fredoka(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/alarm.svg',
                                  color: Colors.green,
                                  width: 50,
                                ),
                                Text(
                                  '${recipe.timeTaken} MIN',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/smiley_medium.svg',
                                  width: 50,
                                ),
                                Text(
                                  recipe.difficulty,
                                  style: TextStyle(
                                    color: Colors.amber.shade700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/fire.svg',
                                  width: 50,
                                  color: Colors.red,
                                ),
                                Text(
                                  '100 cal',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Ingredients :',
                        style: GoogleFonts.fredoka(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        recipe.ingredients,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),

                      SizedBox(height: 20),
                      Text(
                        'Directions :',
                        style: GoogleFonts.fredoka(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        recipe.directions,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
