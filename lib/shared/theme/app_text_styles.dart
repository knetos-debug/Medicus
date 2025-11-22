import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Application text styles
class AppTextStyles {
  // Headings
  static TextStyle get h1 => GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get h2 => GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get h3 => GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get h4 => GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // Body text
  static TextStyle get bodyLarge => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );

  // Special styles
  static TextStyle get caption => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );

  static TextStyle get button => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  static TextStyle get label => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  // Medical-specific styles
  static TextStyle get diagnosis => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.differential,
      );

  static TextStyle get redFlag => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.redFlag,
      );

  static TextStyle get medication => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.medication,
        fontStyle: FontStyle.italic,
      );
}
