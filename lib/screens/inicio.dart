import 'package:flutter/material.dart';
import 'registrar_planta.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const registrar_planta(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}