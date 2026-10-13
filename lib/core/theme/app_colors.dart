import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors - High-energy, trustworthy fitness marketplace
  static const Color primary = Color(0xFF0D9488); // Teal 600
  static const Color primaryDark = Color(0xFF0F766E); // Teal 700
  static const Color primaryLight = Color(0xFF2DD4BF); // Teal 400
  static const Color accent = Color(0xFF10B981); // Emerald 500
  static const Color accentGold = Color(0xFFF59E0B); // Amber 500 for ratings/rewards

  // Dark Neutrals
  static const Color backgroundDark = Color(0xFF0A0F1D); // Deep Navy Slate
  static const Color surfaceDark = Color(0xFF131D31); // Card Surface
  static const Color surfaceDarkCard = Color(0xFF1E293B); // Raised Surface
  static const Color borderDark = Color(0xFF334155); // Slate 700

  // Light Neutrals
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate 50
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceLightCard = Color(0xFFF1F5F9); // Slate 100
  static const Color borderLight = Color(0xFFE2E8F0); // Slate 200

  // Text Colors
  static const Color textLightPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textLightSecondary = Color(0xFF64748B); // Slate 500
  static const Color textLightMuted = Color(0xFF94A3B8); // Slate 400

  static const Color textDarkPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color textDarkSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color textDarkMuted = Color(0xFF64748B); // Slate 500

  // Status & Feedback
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color info = Color(0xFF3B82F6); // Blue 500

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0A0F1D), Color(0xFF132338)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF131D31), Color(0xFF1A263E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

