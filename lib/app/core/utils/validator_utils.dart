/// Validator utility functions for the RoinTech project
library;

import 'package:flutter/services.dart';

class ValidatorUtils {
  /// Validate a 10-digit Indian mobile number
  static bool isValidMobile(String number) {
    return RegExp(r'^[6-9]\d{9}$').hasMatch(number);
  }

  /// Validate a 4-digit OTP
  static bool isValidOtp(String otp) {
    return RegExp(r'^\d{4}$').hasMatch(otp);
  }

  /// Validate a password (at least 6 characters, at least one number)
  static bool isValidPassword(String password) {
    return password.length >= 6 && RegExp(r'[0-9]').hasMatch(password);
  }

  /// Validate a name (letters and spaces only, at least 2 characters)
  static bool isValidName(String name) {
    return RegExp(r'^[A-Za-z ]{2,}$').hasMatch(name);
  }

  /// Validate a simple email address
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
