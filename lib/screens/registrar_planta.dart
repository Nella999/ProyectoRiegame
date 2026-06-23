import 'package:flutter/material.dart';

class registrar_planta extends StatelessWidget {
  const registrar_planta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Planta"),
      ),
      body: const Center(
        child: Text(
          "Formulario de registro",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}