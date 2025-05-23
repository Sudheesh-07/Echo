import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFF9FAFB),
  primaryColor: Color(0xFF6366F1), // Indigo
  cardColor: Colors.white,
  dividerColor: Color(0xFFE5E7EB),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Color(0xFF1F2937),
    elevation: 1,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1F2937),
    ), // Logo or main heading
    titleLarge: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1F2937),
    ), // Section titles
    bodyLarge: GoogleFonts.nunito(
      fontSize: 16,
      color: Color(0xFF1F2937),
    ), // Main text
    bodyMedium: GoogleFonts.nunito(
      fontSize: 14,
      color: Color(0xFF6B7280),
    ), // Subtext or labels
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF6366F1),
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    primary: Color(0xFF6366F1),
    secondary: Color(0xFFFCD34D), // For things like anonymous tags
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF111827),
  primaryColor: Color(0xFF818CF8), // Indigo (soft)
  cardColor: Color(0xFF1F2937),
  dividerColor: Color(0xFF374151),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF1F2937),
    foregroundColor: Color(0xFFF9FAFB),
    elevation: 1,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Color(0xFFF9FAFB),
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Color(0xFFF9FAFB),
    ),
    bodyLarge: GoogleFonts.nunito(fontSize: 16, color: Color(0xFFF9FAFB)),
    bodyMedium: GoogleFonts.nunito(fontSize: 14, color: Color(0xFF9CA3AF)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF818CF8),
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF818CF8),
    secondary: Color(0xFFFBBF24), // Anonymous tags
  ),
);
