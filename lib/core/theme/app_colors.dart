import 'package:flutter/material.dart';

/// Centralized semantic color tokens for Homio SaaS platform.
/// Ensures intentional, accessible (WCAG compliant) light and dark themes.
abstract class AppColors {
  // Brand Palette - Modern Electric Indigo & Vibrant Violet
  static const Color primary = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryHover = Color(0xFF4338CA); // Indigo 700
  static const Color primaryLight = Color(0xFF6366F1); // Indigo 500
  static const Color primaryDark = Color(0xFF3730A3); // Indigo 800
  static const Color primaryMuted = Color(0xFFEEF2FF); // Indigo 50
  static const Color primaryMutedDark = Color(0xFF1E1B4B); // Indigo 950

  static const Color secondary = Color(0xFF7C3AED); // Violet 600
  static const Color secondaryLight = Color(0xFF8B5CF6); // Violet 500
  static const Color accent = Color(0xFF06B6D4); // Cyan 500
  static const Color accentTeal = Color(0xFF0D9488); // Teal 600

  // Semantic Status Colors
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color successMuted = Color(0xFFECFDF5);
  static const Color successMutedDark = Color(0xFF064E3B);

  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color warningMuted = Color(0xFFFFFBEB);
  static const Color warningMutedDark = Color(0xFF78350F);

  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color errorMuted = Color(0xFFFEF2F2);
  static const Color errorMutedDark = Color(0xFF7F1D1D);

  static const Color info = Color(0xFF3B82F6); // Blue 500
  static const Color infoMuted = Color(0xFFEFF6FF);
  static const Color infoMutedDark = Color(0xFF1E3A8A);

  // Light Theme Surfaces & Text
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubtle = Color(0xFFF1F5F9); // Slate 100
  static const Color lightSurfaceElevated = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0); // Slate 200
  static const Color lightBorderStrong = Color(0xFFCBD5E1); // Slate 300
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF475569); // Slate 600
  static const Color lightTextMuted = Color(0xFF94A3B8); // Slate 400

  // Dark Theme Surfaces & Text (Rich obsidian & navy tones, never pure flat black)
  static const Color darkBackground = Color(0xFF0B0F19); // Deep Slate/Obsidian
  static const Color darkSurface = Color(0xFF111827); // Gray 900
  static const Color darkSurfaceSubtle = Color(0xFF161F30); // Deep subtle container
  static const Color darkSurfaceElevated = Color(0xFF1F2937); // Gray 800
  static const Color darkBorder = Color(0xFF1F2937); // Subtle border
  static const Color darkBorderStrong = Color(0xFF374151); // Gray 700
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color darkTextMuted = Color(0xFF64748B); // Slate 500

  // Semantic Card and Text Aliases
  static const Color lightCard = lightSurface;
  static const Color darkCard = darkSurface;
  static const Color lightMutedText = lightTextMuted;
  static const Color darkMutedText = darkTextMuted;
  static const Color lightText = lightTextPrimary;
  static const Color darkText = darkTextPrimary;

  // Gradients for Hero & Highlights
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient heroGlowLight = RadialGradient(
    center: Alignment(0.0, -0.4),
    radius: 1.2,
    colors: [
      Color(0x1A4F46E5),
      Color(0x0A7C3AED),
      Colors.transparent,
    ],
    stops: [0.0, 0.4, 1.0],
  );

  static const Gradient heroGlowDark = RadialGradient(
    center: Alignment(0.0, -0.4),
    radius: 1.2,
    colors: [
      Color(0x334F46E5),
      Color(0x1F7C3AED),
      Colors.transparent,
    ],
    stops: [0.0, 0.4, 1.0],
  );
}
