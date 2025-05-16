import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Font families
  static const String fontPoppins = 'Poppins';
  static const String fontInter = 'Inter';
  static const String fontMontserrat = 'Montserrat';
  static const String fontInstrumentSans = 'Instrument Sans';
  
  // Font weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extrabold = FontWeight.w800;
  
  // Colors
  static const Color _textColorPrimary = Color(0xFF212121);
  static const Color _textColorblack = Color(0xFF000000);
  static const Color _textColorSecondary = Color(0xFF757575);
  static const Color _textColorWhite = Color(0xFFFFFFFF);
  
  // ============== POPPINS STYLES ==============
  
  static TextStyle poppinsH1({Color color = _textColorPrimary}) {
    return GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: bold,
      color: color,
    );
  }
  
  static TextStyle poppinsH2({Color color = _textColorPrimary}) {
    return GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: semiBold,
      color: color,
    );
  }
  
  static TextStyle poppinsBody({
    Color color = _textColorPrimary,
    FontWeight weight = regular,
    double fontSize = 14,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: weight,
      color: color,
    );
  }
  
  // ============== INTER STYLES ==============
  
  static TextStyle interH1({Color color = _textColorPrimary}) {
    return GoogleFonts.inter(
      fontSize: 24,
      fontWeight: bold,
      color: color,
    );
  }
  
  static TextStyle interH2({Color color = _textColorPrimary}) {
    return GoogleFonts.inter(
      fontSize: 20,
      fontWeight: semiBold,
      color: color,
    );
  }
  
  static TextStyle interBody({
    Color color = _textColorPrimary,
    FontWeight weight = regular,
    double fontSize = 14,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: weight,
      color: color,
    );
  }
  
  // ============== MONTSERRAT STYLES ==============
  
  static TextStyle montserratH1({Color color = _textColorPrimary}) {
    return GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: bold,
      color: color,
    );
  }
  
  static TextStyle montserratH2({Color color = _textColorPrimary}) {
    return GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: semiBold,
      color: color,
    );
  }
  
  static TextStyle montserratBody({
    Color color = _textColorPrimary,
    FontWeight weight = regular,
    double fontSize = 14,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: weight,
      color: color,
    );
  }
  
  // ============== INSTRUMENT SANS STYLES ==============
  
  static TextStyle instrumentSansH1({Color color = _textColorPrimary}) {
    return GoogleFonts.instrumentSans(
      fontSize: 24,
      fontWeight: bold,
      color: color,
    );
  }
  
  static TextStyle instrumentSansH2({Color color = _textColorPrimary}) {
    return GoogleFonts.instrumentSans(
      fontSize: 20,
      fontWeight: semiBold,
      color: color,
    );
  }
  
  static TextStyle instrumentSansBody({
    Color color = _textColorPrimary,
    FontWeight weight = regular,
    double fontSize = 14,
  }) {
    return GoogleFonts.instrumentSans(
      fontSize: fontSize,
      fontWeight: weight,
      color: color,
    );
  }
  
  // ============== GENERIC STYLES (POPPINS DEFAULT) ==============
  
  // Heading styles - Poppins by default
  static TextStyle h1({Color color = _textColorPrimary}) {
    return poppinsH1(color: color);
  }
  
  static TextStyle h2({Color color = _textColorPrimary}) {
    return poppinsH2(color: color);
  }
  
  static TextStyle h3({Color color = _textColorPrimary}) {
    return GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: semiBold,
      color: color,
    );
  }
  
  // Body text styles - Poppins by default
  static TextStyle bodyLarge({
    Color color = _textColorPrimary,
    FontWeight weight = regular,
  }) {
    return poppinsBody(color: color, weight: weight, fontSize: 16);
  }
  
  static TextStyle bodyMedium({
    Color color = _textColorPrimary,
    FontWeight weight = regular,
  }) {
    return poppinsBody(color: color, weight: weight, fontSize: 14);
  }
  
  static TextStyle bodySmall({
    Color color = _textColorSecondary,
    FontWeight weight = regular,
  }) {
    return poppinsBody(color: color, weight: weight, fontSize: 12);
  }
  
  // Button text styles - Poppins by default
  static TextStyle button({
    Color color = _textColorWhite,
    FontWeight weight = semiBold,
  }) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: weight,
      color: color,
      letterSpacing: 0.5,
    );
  }
  
  // Label styles - Poppins by default
  static TextStyle label({
    Color color = _textColorSecondary,
    FontWeight weight = medium,
  }) {
    return GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: weight,
      color: color,
      letterSpacing: 0.5,
    );
  }
  
  // Caption style - Poppins by default
  static TextStyle caption({
    Color color = _textColorSecondary,
    FontWeight weight = regular,
  }) {
    return GoogleFonts.poppins(
      fontSize: 10,
      fontWeight: weight,
      color: color,
    );
  }
  
  // Fungsi untuk mengganti font
  static TextStyle changeFont(TextStyle style, String fontFamily) {
    return GoogleFonts.getFont(
      fontFamily,
      fontSize: style.fontSize,
      fontWeight: style.fontWeight,
      color: style.color,
      letterSpacing: style.letterSpacing,
      height: style.height,
      decorationStyle: style.decorationStyle,
      decoration: style.decoration,
      decorationColor: style.decorationColor,
      decorationThickness: style.decorationThickness,
    );
  }
}