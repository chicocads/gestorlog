import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DrawerMenuItem extends StatelessWidget {
  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && onTap != null;
    final itemColor = isEnabled
        ? (color ?? AppColors.textPrimary)
        : AppColors.textSecondary;
    return ListTile(
      leading: Icon(icon, color: itemColor),
      title: Text(
        label,
        style: TextStyle(color: itemColor, fontWeight: FontWeight.w500),
      ),
      onTap: isEnabled ? onTap : null,
      horizontalTitleGap: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
