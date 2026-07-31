import 'package:flutter/material.dart';

class AuditoriaCard extends StatelessWidget {
  const AuditoriaCard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(padding: const EdgeInsets.all(10), child: child),
    );
  }
}
