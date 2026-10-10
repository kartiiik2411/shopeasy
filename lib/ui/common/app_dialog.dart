import 'package:flutter/material.dart';

import '../../core/theme/app_color.dart';
import '../../core/theme/app_size.dart';

class AppDialog {
  AppDialog._();

  static Future<void> showError(BuildContext context, String message) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.error_outline_rounded,
          color: AppColors.error,
          size: AppSize.iconXXL,
        ),
        title: const Text('Login failed'),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusL),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
