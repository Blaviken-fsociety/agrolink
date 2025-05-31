import 'package:flutter/material.dart';

class AppColors {
  // Colores principales según la paleta sugerida
  static const Color primaryGreen = Color(0xFF4CAF50);      // Verde intermedio
  static const Color darkGreen = Color(0xFF2E7D32);         // Verde oscuro
  static const Color lightGreen = Color(0xFFE6F4EA);        // Verde claro suave
  static const Color softBackground = Color(0xFFFAF9F6);    // Beige claro/crema
  static const Color greyText = Color(0xFF424242);          // Gris muy oscuro
  
  // Colores adicionales para mejor experiencia
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  
  // Gradientes
  static const LinearGradient greenGradient = LinearGradient(
    colors: [lightGreen, primaryGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}