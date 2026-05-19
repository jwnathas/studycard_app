import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFF8FAFE);
  static const foreground = Color(0xFF0B111F);
  static const card = Color(0xFFFFFFFF);
  static const primary = Color(0xFF4963DE);
  static const primaryGlow = Color(0xFF8B8DFF);
  static const primaryForeground = Color(0xFFFCFCFD);
  static const secondary = Color(0xFFEEF2F9);
  static const muted = Color(0xFFEEF2F9);
  static const mutedForeground = Color(0xFF6B7689);
  static const border = Color(0xFFE2E8F0);
  static const input = Color(0xFFE2E8F0);

  // Cores dos módulos (Seção 5.3)
  static const blue = Color(0xFF3B82F6);
  static const purple = Color(0xFF8B5CF6); // O que estava faltando!
  static const green = Color(0xFF10B981);
  static const orange = Color(0xFFF59E0B);
  static const red = Color(0xFFEF4444); // Adicionada conforme imagem esperada

  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryGlow],
  );
}
