import 'package:flutter/material.dart';
import '../models/planta.dart';
import '../viewmodels/planta_viewmodel.dart';

//Cambia dinámicamente su color de fondo y borde según el estado de riego.
class PlantaCard extends StatelessWidget {
  final Planta planta;
  final VoidCallback onDelete; // Acción a ejecutar al presionar borrar.
  final VoidCallback onTap;    // Acción a ejecutar al tocar la tarjeta.
  
  // Consultar el estado de riego en tiempo real.
  final PlantaViewModel viewModel = PlantaViewModel();

  PlantaCard({
    super.key,
    required this.planta,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Para obtener la fecha del último riego y decidir el color del card.
    return FutureBuilder<DateTime?>(
      future: viewModel.obtenerUltimoRiego(planta.id),
      builder: (context, snapshot) {
        // Valores por defecto
        Color colorCard = Colors.red.shade50;
        Color colorBorde = Colors.red;
        String estado = "Sin registros";

        if (snapshot.hasData && snapshot.data != null) {
          // Si hay datos, calculamos el estado exacto usando PlantaUtils
          estado = viewModel.obtenerEstadoRiego(snapshot.data!, planta.frecuenciaDias);
          final colorKey = viewModel.obtenerColorEstado(snapshot.data!, planta.frecuenciaDias);
          
          // Asignación de colores semánticos.
          switch (colorKey) {
            case "verde":
              colorCard = Colors.green.shade50;
              colorBorde = Colors.green;
              break;
            case "amarillo":
              colorCard = Colors.orange.shade50;
              colorBorde = Colors.orange;
              break;
            default:
              colorCard = Colors.red.shade50;
              colorBorde = Colors.red;
          }
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: colorCard,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: colorBorde, width: 2),
          ),
          child: ListTile(
            onTap: onTap,
            leading: CircleAvatar(
              backgroundColor: colorBorde,
              child: const Icon(Icons.local_florist, color: Colors.white),
            ),
            title: Text(
              planta.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Apodo: ${planta.apodo}"),
                Text("💧 Cada ${planta.frecuenciaDias} días"),
                const SizedBox(height: 8),
                // Etiqueta visual del estado (ej: "Excelente").
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorBorde,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    estado,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: "Eliminar planta",
            ),
          ),
        );
      },
    );
  }
}
