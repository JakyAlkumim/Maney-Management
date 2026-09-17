import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ','; // الفاصلة التي تريدها

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    // إزالة أي فواصل قديمة لمعالجة الرقم الصافي
    String newValueText = newValue.text.replaceAll(separator, '');

    // تنسيق الرقم بوضع فواصل كل 3 خانات
    final double? doubleValue = double.tryParse(newValueText);
    if (doubleValue == null) return oldValue;

    final formatter = NumberFormat("#,###.##"); // تنسيق آلاف مع خانتين عشريتين
    String newText = formatter.format(doubleValue);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}