import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Formateador de moneda chilena sin decimales
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Eliminar todos los caracteres que no sean dígitos
    String cleanedText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Convertir el texto a un número entero
    int value = int.tryParse(cleanedText) ?? 0;

    // Formatear el número con separador de miles
    String formattedText = _formatCurrency(value);

    // Calcular la posición del cursor
    int cursorPosition = formattedText.length;

    // Si el usuario está borrando, ajustar la posición del cursor
    if (oldValue.text.length > newValue.text.length) {
      cursorPosition = newValue.selection.baseOffset;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  // Función para formatear el número con separador de miles
  String _formatCurrency(int value) {
    final formatter = NumberFormat.decimalPattern('es_CL');
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 0;
    return formatter.format(value).replaceAll(',', '.');
  }
}

// Función para eliminar el formato de moneda
String removeCurrencyFormat(String text) {
  return text.replaceAll(RegExp(r'[^\d]'), '');
}
