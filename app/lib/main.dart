import 'package:app/features/home/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFDCDCDC)),

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
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
          ),

          titleLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          titleMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          titleSmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),

          bodyLarge: GoogleFonts.lora(fontWeight: FontWeight.w400),
          bodyMedium: GoogleFonts.lora(fontWeight: FontWeight.w400),
          bodySmall: GoogleFonts.lora(fontWeight: FontWeight.w400),

          labelLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500),
          labelMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500),
          labelSmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
