import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void selectAllText(TextEditingController controller) {
  controller.selection = TextSelection(
    baseOffset: 0,
    extentOffset: controller.text.length,
  );
}

class AppIntField extends StatelessWidget {
  const AppIntField({super.key, required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onTap: () => selectAllText(controller),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Informe $label.' : null,
    );
  }
}
