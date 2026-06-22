import 'package:app/features/book/presentation/screen/book_screen.dart';
import 'package:app/features/home/presentation/pages/home_screen.dart';

import 'package:app/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;

    return MaterialApp(
      title: 'Stridely',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF58B4FE), // Strict blue primary
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xFFF3F3F3),
          tertiary: Color.fromARGB(255, 1, 1, 2),
          surface: Color.fromARGB(
            255,
            255,
            255,
            255,
          ), // Cards/Sheets background
          onSurface: Color(0xC9151515),
        ),
        scaffoldBackgroundColor: const Color(0xFF000000),

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
            // color: Color(0xD2FFFFFF),
            fontSize: 22,
            letterSpacing: 1.5,
            color: Color.fromARGB(210, 30, 29, 29),
          ),
          headlineMedium: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 17,

            color: Color.fromARGB(210, 30, 29, 29),
          ),
          headlineSmall: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            color: themeColors.secondary,
            // color: Color.fromARGB(194, 255, 255, 255),
            fontSize: 14,
          ),

          titleLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          titleMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          titleSmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),

          bodyLarge: GoogleFonts.lora(
            fontWeight: FontWeight.w400,
            color: themeColors.onSurface,
            fontSize: 18,
          ),
          bodyMedium: GoogleFonts.lora(
            fontWeight: FontWeight.w400,
            color: themeColors.onSurface,
            fontSize: 16,
            wordSpacing: 8
          ),
          bodySmall: GoogleFonts.lora(
            fontWeight: FontWeight.w400,
            color: themeColors.onSurface,
            fontSize: 14,
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
