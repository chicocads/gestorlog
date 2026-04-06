import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AuditoriaView extends StatelessWidget {
  const AuditoriaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auditoria de Estoque'), elevation: 0),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.fact_check_outlined, size: 72, color: AppColors.accent),
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
