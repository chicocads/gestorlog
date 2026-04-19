import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueStyle,
    this.labelStyle,
    this.labelWidth = 85,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;
  final TextStyle? labelStyle;
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    final normalizedLabel = label.trimRight();
    final labelText =
        normalizedLabel.endsWith(':') ? normalizedLabel : '$normalizedLabel:';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              labelText,
              style:
                  labelStyle ??
                  const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style:
                  valueStyle ??
                  const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
