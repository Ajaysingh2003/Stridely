import 'package:app/features/book/presentation/screen/book_screen.dart';
import 'package:app/features/home/presentation/pages/home_screen.dart';

import 'package:app/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stridely',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF000000)),

        textTheme: TextTheme(
          displayLarge: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
          ),
          displayMedium: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
          ),
          displaySmall: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
          ),

          headlineLarge: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          headlineSmall: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),

          titleLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          titleMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          titleSmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),

          bodyLarge: GoogleFonts.lora(fontWeight: FontWeight.w400),
          bodyMedium: GoogleFonts.lora(
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 16,
          ),
          bodySmall: GoogleFonts.lora(
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),

          labelLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500),
          labelMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500),
          labelSmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // home: const HomePage(),
      home: const BookPage(),
    );
  }
}
