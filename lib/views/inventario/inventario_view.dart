import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class InventarioView extends StatelessWidget {
  const InventarioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conferência de Inventário'), elevation: 0),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 72, color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              'Em desenvolvimento',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
