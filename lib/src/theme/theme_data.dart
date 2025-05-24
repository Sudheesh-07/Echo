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
    secondary: Color(0xFFFCD34D), // For things like anonymous tags
  ),
);

/// This is for the dark theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF111827),
  primaryColor: const Color(0xFF6366F1), // Indigo (soft)
  cardColor: const Color(0xFF1F2937),
  dividerColor: const Color(0xFF374151),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F2937),
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
      color: const Color(0xFF9CA3AF),
      fontWeight: FontWeight.w300,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF6366F1),
    foregroundColor: Colors.white,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF6366F1),
    secondary: Color(0xFFFBBF24), // Anonymous tags
  ),
);
