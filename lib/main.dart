import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipia/routing/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
    );
  }
}
