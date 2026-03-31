import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipia/data/remote_datasources/auth_remote_datasource.dart';
import 'package:recipia/data/remote_datasources/recipe_remote_datasource.dart';
import 'package:recipia/firebase_options.dart';
import 'package:recipia/presentations/cubits/auth/auth_cubit.dart';
import 'package:recipia/presentations/cubits/recipe/recipe_cubit.dart';
import 'package:recipia/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(AuthRemoteDatasource())),
        BlocProvider(
          create: (context) => RecipeCubit(RecipeRemoteDatasource()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
          ),
          textTheme: GoogleFonts.fredokaTextTheme(),
        ),
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
