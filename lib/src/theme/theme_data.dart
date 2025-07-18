import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// This is for the light theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF9FAFB),
  primaryColor: const Color(0xFF6366F1), // Indigo
  cardColor: Colors.white,
  dividerColor: const Color(0xFFE5E7EB),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Color(0xFF1F2937),
    elevation: 1,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF1F2937),
    ), // Logo or main heading
    titleLarge: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF1F2937),
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF1F2937),
    ), // Section titles
    bodyLarge: GoogleFonts.nunito(
      fontSize: 16,
      color: const Color(0xFF1F2937),
    ), // Main text
    bodyMedium: GoogleFonts.nunito(
      fontSize: 14,
      color: const Color(0xFF6B7280),
    ), // Subtext or labels
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF6366F1),
    foregroundColor: Colors.white,
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF6366F1),
    secondary: Color(0xFFFCD34D),
    primaryFixedDim: Color(0xFF9CA3AF),
    // ignore: avoid_redundant_argument_values
    surface: Colors.white,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      borderSide: BorderSide(color: Color(0xFF374151)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      borderSide: BorderSide(color: Color(0xFF374151)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      borderSide: BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
    filled: true,
    fillColor: Colors.white,
  ),
);

/// This is for the dark theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0B0F19), // darker background
  primaryColor: const Color(0xFF6366F1), // Indigo (soft)
  cardColor: const Color(0xFF12151C), // darker card
  dividerColor: const Color(0xFF1A1D24), // darker divider
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF12151C),
    foregroundColor: Color(0xFFF9FAFB),
    elevation: 1,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFF9FAFB),
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: const Color(0xFFF9FAFB),
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: const Color(0xFFF9FAFB),
    ),
    bodyLarge: GoogleFonts.nunito(
      fontSize: 16,
      color: const Color(0xFFF9FAFB),
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.nunito(
      fontSize: 14,
      color: const Color(0xFFF9FAFB),
      fontWeight: FontWeight.w400,
    ),
    bodySmall: GoogleFonts.nunito(
      fontSize: 12,
      color: const Color.fromARGB(
        255,
        178,
        180,
        182,
      ), // slightly muted grey for readability
      fontWeight: FontWeight.w300,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF6366F1),
    foregroundColor: Colors.white,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF6366F1),
    secondary: Color(0xFFFBBF24),
    onPrimary: Colors.white,
    primaryFixedDim: Color(0xFF4B5563), // darker muted tone
    surface: Color(0xFF12151C),
    outline: const Color(0xFF1A1D24),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      borderSide: BorderSide(color: Color(0xFF6366F1)),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(color: Colors.red),
    ),
    fillColor: Color(0xFF1F2937),
    filled: true,
  ),
);
