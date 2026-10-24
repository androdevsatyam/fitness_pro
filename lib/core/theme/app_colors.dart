import 'package:flutter/material.dart';

/// Shared, calm wellness palette. Legacy aliases keep existing mock flows aligned.
class AppColors {
  static const primary = Color(0xFF285447);
  static const primaryDark = Color(0xFF203F36);
  static const primaryLight = primary;
  static const accent = Color(0xFF52715D);
  static const accentGold = Color(0xFF986E35);
  static const canvas = Color(0xFFFAF9F5);
  static const paper = Color(0xFFFFFFFF);
  static const soft = Color(0xFFF0F2EB);
  static const line = Color(0xFFE1E5DC);
  static const ink = Color(0xFF263D34);
  static const muted = Color(0xFF66736A);
  static const backgroundDark = canvas;
  static const surfaceDark = paper;
  static const surfaceDarkCard = soft;
  static const borderDark = line;
  static const backgroundLight = canvas;
  static const surfaceLight = paper;
  static const surfaceLightCard = soft;
  static const borderLight = line;
  static const textDarkPrimary = ink;
  static const textDarkSecondary = muted;
  static const textDarkMuted = muted;
  static const textLightPrimary = ink;
  static const textLightSecondary = muted;
  static const textLightMuted = muted;
  static const success = Color(0xFF397056);
  static const warning = Color(0xFF916728);
  static const error = Color(0xFFB5473E);
  static const info = Color(0xFF456B80);
  static const primaryGradient = LinearGradient(colors: [primary, accent]);
  static const heroGradient = LinearGradient(colors: [canvas, soft]);
  static const cardGradient = LinearGradient(colors: [paper, soft]);
}
