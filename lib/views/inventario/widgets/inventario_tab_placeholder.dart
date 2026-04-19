import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class InventarioTabPlaceholder extends StatelessWidget {
  const InventarioTabPlaceholder({
    super.key,
    required this.icon,
    required this.titulo,
  });

  final IconData icon;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 72, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Em desenvolvimento',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
