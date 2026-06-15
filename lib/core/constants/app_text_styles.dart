import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Poppins - Brand Voice (headings, navigation, labels)
  static TextStyle get displaySale => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.onSurface,
        letterSpacing: -0.02,
      );

  static TextStyle get displaySaleMobile => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineSection => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );

  static TextStyle get tabLabel => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurfaceVariant,
        letterSpacing: 0.05,
      );

  static TextStyle get searchText => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      );

  static TextStyle get labelSm => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );

  // Roboto - Workhorse (descriptions, prices, fine print)
  static TextStyle get bodyMd => GoogleFonts.roboto(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      );

  static TextStyle get priceCopy => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
      );

  // Backward compatibility aliases
  static TextStyle get displayLarge => displaySale;
  static TextStyle get displayMedium => displaySaleMobile;
  static TextStyle get headline1 => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
      );
  static TextStyle get headline2 => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );
  static TextStyle get headline3 => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );
  static TextStyle get title => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );
  static TextStyle get subtitle => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );
  static TextStyle get body => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      );
  static TextStyle get bodySmall => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );
  static TextStyle get caption => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );
  static TextStyle get label => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );
  static TextStyle get button => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      );
  static TextStyle get buttonOutline => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      );
  static TextStyle get price => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      );
  static TextStyle get priceSmall => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );
  static TextStyle get oldPrice => GoogleFonts.roboto(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        decoration: TextDecoration.lineThrough,
      );
  static TextStyle get badge => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      );
  static TextStyle get saleHeading => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: AppColors.white,
      );
  static TextStyle get sectionLabel => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );
  static TextStyle get searchPlaceholder => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textHint,
      );
  static TextStyle get brandName => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      );
  static TextStyle get navLabel => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      );
  static TextStyle get navLabelActive => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      );
  static TextStyle get topBar => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
      );
  static TextStyle get ctaButton => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );
  static TextStyle get sectionHeading => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
      );
  static TextStyle get sectionSubtext => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );
  static TextStyle get blogTitle => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );
  static TextStyle get blogAuthor => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        color: AppColors.textSecondary,
      );
  static TextStyle get footerHeading => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );
  static TextStyle get footerLink => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );
  static TextStyle get heroTitle => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w300,
        color: AppColors.onSurface,
      );
  static TextStyle get navLink => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      );
}
