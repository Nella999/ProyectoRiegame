import 'package:flutter/material.dart';
//Campo de texto reutilizable para los formularios de la aplicación.
class CampoTexto extends StatelessWidget {

  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;

  const CampoTexto({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}