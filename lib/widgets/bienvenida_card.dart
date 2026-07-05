import 'package:flutter/material.dart';
//Tarjeta de bienvenida que se muestra en la pantalla principal.
class BienvenidaCard extends StatelessWidget {
  const BienvenidaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(
              Icons.local_florist,
              color: Colors.green,
              size: 45,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "¡Bienvenido a Riégame!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Administra el riego de todas tus plantas de manera sencilla.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}