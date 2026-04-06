import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppSnackBar {
  AppSnackBar._();

  static void sucesso(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.success),
    );
  }

  static void erro(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.replaceAll('Exception:', '').trim()),
        backgroundColor: AppColors.error,
      ),
    );
  }
}
