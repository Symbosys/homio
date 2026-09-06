import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized typographic scale for Homio SaaS using Plus Jakarta Sans.
abstract class AppTypography {
  static TextTheme lightTextTheme = _buildTextTheme(
    primaryColor: AppColors.lightTextPrimary,
    secondaryColor: AppColors.lightTextSecondary,
    mutedColor: AppColors.lightTextMuted,
  );

  static TextTheme darkTextTheme = _buildTextTheme(
    primaryColor: AppColors.darkTextPrimary,
    secondaryColor: AppColors.darkTextSecondary,
    mutedColor: AppColors.darkTextMuted,
  );

  // Static Direct Style Accessors
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
        fontSize: 52,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.8,
        height: 1.12,
      );

  static TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
        height: 1.16,
      );

  static TextStyle get displaySmall => GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        height: 1.2,
      );

  static TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        height: 1.25,
      );

  static TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        height: 1.3,
      );

  static TextStyle get headlineSmall => GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.35,
      );

  static TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.4,
      );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.45,
      );

  static TextStyle get titleSmall => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.0,
        height: 1.5,
      );

  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.1,
        height: 1.6,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.0,
        height: 1.55,
      );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.5,
      );

  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        height: 1.4,
      );

  static TextStyle get labelMedium => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        height: 1.4,
      );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        height: 1.3,
      );

  static TextTheme _buildTextTheme({
    required Color primaryColor,
    required Color secondaryColor,
    required Color mutedColor,
  }) {
    final baseTheme = GoogleFonts.plusJakartaSansTextTheme();

    return baseTheme.copyWith(
      displayLarge: displayLarge.copyWith(color: primaryColor),
      displayMedium: displayMedium.copyWith(color: primaryColor),
      displaySmall: displaySmall.copyWith(color: primaryColor),
      headlineLarge: headlineLarge.copyWith(color: primaryColor),
      headlineMedium: headlineMedium.copyWith(color: primaryColor),
      headlineSmall: headlineSmall.copyWith(color: primaryColor),
      titleLarge: titleLarge.copyWith(color: primaryColor),
      titleMedium: titleMedium.copyWith(color: primaryColor),
      titleSmall: titleSmall.copyWith(color: secondaryColor),
      bodyLarge: bodyLarge.copyWith(color: secondaryColor),
      bodyMedium: bodyMedium.copyWith(color: secondaryColor),
      bodySmall: bodySmall.copyWith(color: mutedColor),
      labelLarge: labelLarge.copyWith(color: primaryColor),
      labelMedium: labelMedium.copyWith(color: primaryColor),
      labelSmall: labelSmall.copyWith(color: mutedColor),
    );
  }
}
