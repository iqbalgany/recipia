import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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

  String _selectedDificulty = 'Easy';
  bool _isTodayRecipe = false;
  bool _isRecommended = false;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipeCubit, RecipeState>(
      listener: (context, recipeState) {
        if (recipeState.status == RecipeStatus.success) {
          context.pop();
          _recipeNameController.clear();
          _timeTakenController.clear();
          _ingredientsController.clear();
          _directionsController.clear();
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
                      _addRecipeTextField(
                        controller: _recipeNameController,
                        hint: 'Enter Recipe Name',
                      ),
                      SizedBox(height: 20),

                      // Pick Image
                      Text(
                        'Pick Image',
                        style: GoogleFonts.fredoka(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: _imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(
                                    _imageFile!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Text(
                                        'Gambar tidak ditemukan',
                                      );
                                    },
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo_rounded, size: 50),
                                    Text('Tap to pick an image'),
                                  ],
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
                      _addRecipeTextField(
                        hint: 'Time Taken (in minutes)',
                        controller: _timeTakenController,
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
                      _addRecipeTextField(
                        hint: 'Ingredients',
                        controller: _ingredientsController,
                        maxLines: 5,
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
                      _addRecipeTextField(
                        hint: 'Directions',
                        controller: _directionsController,
                        maxLines: 5,
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Difficulty',
                        style: GoogleFonts.fredoka(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      DropdownButtonFormField(
                        initialValue: _selectedDificulty,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blue.shade100,
                          hintText: ' ',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: ['Easy', 'Medium', 'Hard']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (value) => setState(() {
                          _selectedDificulty = value!;
                        }),
                      ),
                      SizedBox(height: 20),

                      // Switches for Today Recipe and Recommended
                      SwitchListTile(
                        title: Text('set as Today\'s Recipe'),
                        value: _isTodayRecipe,
                        onChanged: (value) => setState(() {
                          _isTodayRecipe = value;
                        }),
                      ),
                      SwitchListTile(
                        title: Text('set as Recommended'),
                        value: _isRecommended,
                        onChanged: (value) => setState(() {
                          _isRecommended = value;
                        }),
                      ),
                      SizedBox(height: 40),

                      // Submit Button
                      if (recipeState.status == RecipeStatus.loading)
                        Center(child: CircularProgressIndicator())
                      else
                        Center(
                          child: TextButton(
                            onPressed: _submitForm,
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

  TextFormField _addRecipeTextField({
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextFormField(
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blue.shade100,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hint,
        hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please pick an image for the recipe')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final newRecipe = RecipeModel(
      id: RecipeModel.generateId(),
      recipeName: _recipeNameController.text.trim(),
      difficulty: _selectedDificulty,
      imageUrl: _imageFile!.path,
      isRecommended: _isRecommended,
      isTodayRecipe: _isTodayRecipe,
      timeTaken: int.tryParse(_timeTakenController.text.trim()) ?? 0,
      ingredients: _ingredientsController.text.trim(),
      directions: _directionsController.text.trim(),
    );

    context.read<RecipeCubit>().addNewRecipe(newRecipe);
  }
}
