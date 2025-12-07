import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF5800E4);
  static const Color secondaryColor = Color(0xFF00CDBB);
  static const Color tertiaryColor = Color(0xFF8E2DE2); // Lighter Purple

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.outfit()
        .fontFamily, // Use Outfit as seen in modern apps (or keep Lato if preferred, but Outfit is more heading-friendly)
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      surface: const Color(0xFFF8FAFC), // Light grey background
      onSurface: const Color(0xFF1E293B), // Dark text
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // More rounded
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: TextStyle(color: Colors.grey.shade400, inherit: true),
      prefixIconColor: Colors.grey.shade400,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, inherit: true),
      ),
    ),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: primaryColor.withValues(alpha: 0.1),
      disabledColor: Colors.grey.shade300,
      labelStyle: const TextStyle(
          color: Color(0xFF1E293B), fontWeight: FontWeight.w600, inherit: true),
      secondaryLabelStyle: const TextStyle(
          color: primaryColor, fontWeight: FontWeight.bold, inherit: true),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      showCheckmark: false,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF6366F1), // Vibrant Indigo/Purple
      onPrimary: Colors.white,
      secondary: Color(0xFF03DAC6), // Teal
      onSecondary: Colors.black,
      surface: Color(0xFF1E293B), // Slate 800 (Card Background)
      onSurface: Color(0xFFE0E0E0), // Off-white text
      error: Color(0xFFCF6679),
    ),
    scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900 (Background)
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: const Color(0xFF1E293B), // Slate 800
    cardTheme: CardThemeData(
      color: const Color(0xFF1E293B),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor:
          const Color(0xFF334155), // Slate 700 (Input Box - Lighter than Card)
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(color: Colors.grey.shade400, inherit: true),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, inherit: true),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0F172A),
      selectedItemColor: Color(0xFF6366F1),
      unselectedItemColor: Colors.grey,
    ),
    textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6366F1),
      foregroundColor: Colors.white,
      shape: CircleBorder(),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF334155), // Slate 700 (Unselected)
      selectedColor: const Color(0xFF6366F1), // Indigo (Selected)
      disabledColor: Colors.grey.shade800,
      labelStyle: const TextStyle(color: Colors.white, inherit: true),
      secondaryLabelStyle: const TextStyle(color: Colors.white, inherit: true),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide.none,
      ),
      showCheckmark: false,
    ),
  );
}
