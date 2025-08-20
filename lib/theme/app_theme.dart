import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors
  static const Color _primaryColor = Color(0xFF2196F3);
  static const Color _primaryVariant = Color(0xFF1976D2);
  static const Color _secondaryColor = Color(0xFF03DAC6);
  static const Color _secondaryVariant = Color(0xFF018786);
  
  static const Color _surfaceColor = Color(0xFFFFFFFF);
  static const Color _backgroundColor = Color(0xFFF5F5F5);
  static const Color _errorColor = Color(0xFFB00020);
  
  static const Color _onPrimaryColor = Color(0xFFFFFFFF);
  static const Color _onSecondaryColor = Color(0xFF000000);
  static const Color _onSurfaceColor = Color(0xFF000000);
  static const Color _onBackgroundColor = Color(0xFF000000);
  static const Color _onErrorColor = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color _darkPrimaryColor = Color(0xFF90CAF9);
  static const Color _darkPrimaryVariant = Color(0xFF42A5F5);
  static const Color _darkSecondaryColor = Color(0xFF80DEEA);
  static const Color _darkSecondaryVariant = Color(0xFF4DD0E1);
  
  static const Color _darkSurfaceColor = Color(0xFF121212);
  static const Color _darkBackgroundColor = Color(0xFF000000);
  static const Color _darkErrorColor = Color(0xFFCF6679);
  
  static const Color _darkOnPrimaryColor = Color(0xFF000000);
  static const Color _darkOnSecondaryColor = Color(0xFF000000);
  static const Color _darkOnSurfaceColor = Color(0xFFFFFFFF);
  static const Color _darkOnBackgroundColor = Color(0xFFFFFFFF);
  static const Color _darkOnErrorColor = Color(0xFF000000);

  // Priority Colors
  static const Color _priorityLow = Color(0xFF4CAF50);
  static const Color _priorityMedium = Color(0xFFFF9800);
  static const Color _priorityHigh = Color(0xFFF44336);
  static const Color _priorityUrgent = Color(0xFF9C27B0);

  // Custom Colors
  static const Color _successColor = Color(0xFF4CAF50);
  static const Color _warningColor = Color(0xFFFF9800);
  static const Color _infoColor = Color(0xFF2196F3);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: _primaryColor,
        primaryContainer: _primaryVariant,
        secondary: _secondaryColor,
        secondaryContainer: _secondaryVariant,
        surface: _surfaceColor,
        error: _errorColor,
        onPrimary: _onPrimaryColor,
        onSecondary: _onSecondaryColor,
        onSurface: _onSurfaceColor,
        onError: _onErrorColor,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
        foregroundColor: _onPrimaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _onPrimaryColor,
        ),
        iconTheme: const IconThemeData(color: _onPrimaryColor),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: _surfaceColor,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          backgroundColor: _primaryColor,
          foregroundColor: _onPrimaryColor,
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          side: const BorderSide(color: _primaryColor),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        filled: true,
        fillColor: _surfaceColor,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: _onPrimaryColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _surfaceColor,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: _primaryColor.withOpacity(0.1),
        selectedColor: _primaryColor,
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _primaryColor,
        linearTrackColor: Colors.grey,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Colors.grey,
        thickness: 1,
        space: 1,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: Colors.grey,
        size: 24,
      ),
      
      // Text Theme
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        headlineLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: _onSurfaceColor,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: _onSurfaceColor,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _onSurfaceColor,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _onSurfaceColor,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _onSurfaceColor,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _onSurfaceColor,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _onSurfaceColor,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _onSurfaceColor,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _onSurfaceColor,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimaryColor,
        primaryContainer: _darkPrimaryVariant,
        secondary: _darkSecondaryColor,
        secondaryContainer: _darkSecondaryVariant,
        surface: _darkSurfaceColor,
        error: _darkErrorColor,
        onPrimary: _darkOnPrimaryColor,
        onSecondary: _darkOnSecondaryColor,
        onSurface: _darkOnSurfaceColor,
        onError: _darkOnErrorColor,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: _darkPrimaryColor,
        foregroundColor: _darkOnPrimaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _darkOnPrimaryColor,
        ),
        iconTheme: const IconThemeData(color: _darkOnPrimaryColor),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: _darkSurfaceColor,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          backgroundColor: _darkPrimaryColor,
          foregroundColor: _darkOnPrimaryColor,
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          side: const BorderSide(color: _darkPrimaryColor),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkPrimaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _darkPrimaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        filled: true,
        fillColor: _darkSurfaceColor,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _darkPrimaryColor,
        foregroundColor: _darkOnPrimaryColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _darkSurfaceColor,
        selectedItemColor: _darkPrimaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: _darkPrimaryColor.withOpacity(0.1),
        selectedColor: _darkPrimaryColor,
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _darkPrimaryColor,
        linearTrackColor: Colors.grey,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Colors.grey,
        thickness: 1,
        space: 1,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: Colors.grey,
        size: 24,
      ),
      
      // Text Theme
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        headlineLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: _darkOnSurfaceColor,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: _darkOnSurfaceColor,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _darkOnSurfaceColor,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _darkOnSurfaceColor,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _darkOnSurfaceColor,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _darkOnSurfaceColor,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _darkOnSurfaceColor,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _darkOnSurfaceColor,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _darkOnSurfaceColor,
        ),
      ),
    );
  }

  // Priority Colors
  static Color getPriorityColor(int priority) {
    switch (priority) {
      case 0:
        return _priorityLow;
      case 1:
        return _priorityMedium;
      case 2:
        return _priorityHigh;
      case 3:
        return _priorityUrgent;
      default:
        return _priorityMedium;
    }
  }

  // Status Colors
  static Color getSuccessColor() => _successColor;
  static Color getWarningColor() => _warningColor;
  static Color getInfoColor() => _infoColor;
  static Color getErrorColor() => _errorColor;
}
