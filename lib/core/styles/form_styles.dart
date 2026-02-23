import 'package:flutter/material.dart';

class FormStyles {
  // Label style (small uppercase labels)
  static const TextStyle labelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6B7280),
    letterSpacing: 0.5,
  );

  // Input text style
  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 15,
    color: Color(0xFF1F2937),
  );

  // Hint style
  static const TextStyle hintStyle = TextStyle(
    color: Color(0xFF9CA3AF),
    fontSize: 15,
  );

  // Icon color
  static const Color iconColor = Color(0xFF9CA3AF);

  // Borders and paddings
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(8));
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 14);

  static const OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 1),
  );

  static const OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Color(0xFF3D9970), width: 1),
  );

  static const OutlineInputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Colors.red, width: 1),
  );

  static InputDecoration baseDecoration({IconData? icon, String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: hintStyle,
      prefixIcon: icon != null ? Icon(icon, color: iconColor, size: 20) : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: contentPadding,
      enabledBorder: enabledBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
    );
  }
}
