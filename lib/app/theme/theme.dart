import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF5800E4);
  static const Color secondaryColor = Color(0xFF00CDBB);
  static const Color tertiaryColor = Color(0xFF8E2DE2); // Lighter Purple

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      secondary: secondaryColor,
    ),
    textTheme: GoogleFonts.latoTextTheme(),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFBB86FC), // Lighter purple for dark mode
      onPrimary: Colors.black,
      secondary: Color(0xFF03DAC6), // Teal
      onSecondary: Colors.black,
      surface: Color(0xFF121212), // Dark grey surface
      onSurface: Color(0xFFE0E0E0), // Off-white text
      error: Color(0xFFCF6679),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E), // Slightly lighter than background
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: Color(0xFFBB86FC),
      unselectedItemColor: Colors.grey,
    ),
    textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
  );
}
