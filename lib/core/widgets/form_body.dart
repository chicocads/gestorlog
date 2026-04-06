import 'package:flutter/material.dart';

class FormBody extends StatelessWidget {
  const FormBody({
    super.key,
    required this.formKey,
    required this.children,
    this.padding = const EdgeInsets.all(16),
  });

  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
