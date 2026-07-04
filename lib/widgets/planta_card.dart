import 'package:flutter/material.dart';

import '../models/planta.dart';

class PlantaCard extends StatelessWidget {

  final Planta planta;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const PlantaCard({
    super.key,
    required this.planta,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      margin: const EdgeInsets.all(10),

      child: ListTile(

        onTap: onTap,

        leading: const Icon(
          Icons.local_florist,
          color: Colors.green,
        ),

        title: Text(planta.nombre),

        subtitle: Text(
          "Apodo: ${planta.apodo}\n"
              "💧 Cada ${planta.frecuenciaDias} días",
        ),

        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: onDelete,
        ),

      ),

    );
  }
}