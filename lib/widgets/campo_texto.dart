import 'package:flutter/material.dart';

/// Un widget de campo de texto personalizado y reutilizable.
class CampoTexto extends StatelessWidget {
  final TextEditingController controller; // Controlador para manejar el valor del texto.
  final String label;                      // Etiqueta que se muestra sobre el campo.
  final TextInputType keyboardType;        // Tipo de teclado

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
          // Se puede añadir más estilo aquí (iconos, colores, etc.)
        ),
      ),
    );
  }
}
