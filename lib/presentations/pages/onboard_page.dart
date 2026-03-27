import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipia/routing/app_router.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Image.asset('assets/images/onboard2.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '75+ PREMIUM RECIPIES',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'It\'s\nCooking Time!',
              style: GoogleFonts.fredoka(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 40),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                context.go(AppRoutes.home);
              },
              style: ButtonStyle(
                elevation: WidgetStatePropertyAll(2),
                backgroundColor: WidgetStatePropertyAll(Colors.green.shade500),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
