import 'package:flutter/material.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("¡Riégame!"),
      ),
      body: const Center(
        child: Text(
          "Aun no registraste tu planta :(",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}