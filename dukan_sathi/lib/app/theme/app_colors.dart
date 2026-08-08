import 'package:flutter/material.dart';

/// Dukan Sathi Design System - "Grocer-Tech" Color Tokens (UI/UX Pro Max Edition)
abstract class AppColors {
  // Brand Emerald & Mint Palette
  static const Color primaryEmerald = Color(0xFF0F5132); // Fresh Organic Emerald
  static const Color primaryEmeraldLight = Color(0xFF16A34A); // Vibrant Leaf Emerald
  static const Color primaryEmeraldDark = Color(0xFF0A3622); // Deep Forest Emerald
  static const Color accentMint = Color(0xFF22C55E); // Bright Mint Accent
  static const Color accentMintLight = Color(0xFFDCFCE7); // Soft Mint Tint

  // Warmth & Grain Accents (Bakery & Grains)
  static const Color warmAmber = Color(0xFFF59E0B); // Golden Harvest Amber
  static const Color warmAmberLight = Color(0xFFFEF3C7);
  static const Color warmAmberDark = Color(0xFFD97706);

  // Surface & Canvas (Warm Porcelain)
  static const Color background = Color(0xFFF8FAFC); // Crisp Soft Surface
  static const Color cardBackground = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color darkObsidian = Color(0xFF0F172A); // Dark Slate Charcoal

  // Linear Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0F5132), Color(0xFF16A34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient mintGradient = LinearGradient(
    colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Neutral Text Tokens
  static const Color textPrimary = Color(0xFF0F172A); // High-contrast Dark Charcoal
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);

  // Status & Live Badges
  static const Color success = Color(0xFF10B981); // Live Emerald (Open Now)
  static const Color successLight = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFEF4444); // Soft Crimson (Closed)
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFEFF6FF);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFF1F5F9);
}
