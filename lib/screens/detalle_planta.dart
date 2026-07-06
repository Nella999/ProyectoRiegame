import 'package:flutter/material.dart';
import '../models/planta.dart';
import '../viewmodels/planta_viewmodel.dart';
import 'editar_planta.dart';
import '../widgets/estadisticasPlanta.dart';
import '../services/notification_service.dart';
import '../widgets/historial_cuidados.dart';

//Pantalla detallada de una planta específica.
//Permite ver el estado de salud, historial de riegos, estadísticas y realizar acciones rápidas como registrar riegos o sol.
class DetallePlanta extends StatefulWidget {
  final Planta planta;
  final PlantaViewModel viewModel = PlantaViewModel();

  DetallePlanta({
    super.key,
    required this.planta,
  });

  @override
  State<DetallePlanta> createState() => _DetallePlantaState();
}

class _DetallePlantaState extends State<DetallePlanta> {
  final PlantaViewModel viewModel = PlantaViewModel();

  //Muestra un diálogo emergente para registrar cuántas horas de sol recibió la planta hoy.
  void _registrarHorasSol(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Registrar horas de sol"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Horas",
              hintText: "Ej: 5",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                final horas = int.tryParse(controller.text);
                if (horas == null) return;
                
                await viewModel.registrarHorasSol(widget.planta.id, horas);
                
                if (!mounted) return;
                Navigator.pop(context);
                setState(() {}); // Refresca la vista para mostrar los nuevos datos.
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Horas registradas correctamente ☀️")),
                );
              },
              child: const Text("Guardar"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final planta = widget.planta;
    return Scaffold(
      appBar: AppBar(
        title: Text(planta.nombre),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono representativo de la planta
              const Center(
                child: Icon(
                  Icons.local_florist,
                  size: 90,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 30),
              
              // Sección: Información General
              _buildInfoSection(context, "Nombre", planta.nombre),
              _buildInfoSection(context, "Apodo", planta.apodo),
              _buildInfoSection(context, "Observaciones", planta.observaciones),
              _buildInfoSection(context, "Frecuencia de riego", "Cada ${planta.frecuenciaDias} días"),
              _buildInfoSection(context, "Objetivo horas de sol", "${planta.horasSol} horas"),

              const SizedBox(height: 20),
              
              // Sección: Estado de Riego (Tiempo Real)
              FutureBuilder<DateTime?>(
                future: viewModel.obtenerUltimoRiego(planta.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LinearProgressIndicator();
                  }
                  
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("No existen riegos registrados aún. ¡Dale de beber! 💧"),
                      ),
                    );
                  }

                  final ultimoRiego = snapshot.data!;
                  final proximo = viewModel.calcularProximoRiego(ultimoRiego, planta.frecuenciaDias);
                  final estado = viewModel.obtenerEstadoRiego(ultimoRiego, planta.frecuenciaDias);
                  final colorStr = viewModel.obtenerColorEstado(ultimoRiego, planta.frecuenciaDias);
                  
                  // Mapeo de color string a objeto Color de Flutter
                  Color colorAlerta = colorStr == "verde" ? Colors.green : (colorStr == "amarillo" ? Colors.orange : Colors.red);

                  return Column(
                    children: [
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFechaRiego("Último riego:", ultimoRiego),
                              const SizedBox(height: 12),
                              _buildFechaRiego("Próximo riego:", proximo),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Icon(
                                    colorStr == "verde" ? Icons.check_circle : (colorStr == "amarillo" ? Icons.schedule : Icons.warning),
                                    color: colorAlerta,
                                    size: 30,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Estado de salud", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(estado, style: TextStyle(color: colorAlerta, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Widget externo para gráficas o porcentajes de esta planta.
                      EstadisticasPlanta(plantaId: planta.id),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),
              const Divider(),
              
              //Sección: Historial
              const SizedBox(height: 15),
              Text("Historial de riegos", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 15),
              HistorialCuidados(plantaId: planta.id),
              
              const SizedBox(height: 30),

              // Sección: Acciones
              _buildBotonAccion(
                icon: Icons.edit,
                label: "Editar planta",
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditarPlanta(planta: planta)),
                ),
              ),
              const SizedBox(height: 12),
              _buildBotonAccion(
                icon: Icons.water_drop,
                label: "Regué hoy",
                color: Colors.blue,
                onPressed: () async {
                  await viewModel.registrarRiego(planta.id);
                  // Notificación local para confirmar la acción.
                  await NotificationService.instance.mostrarNotificacion(
                    titulo: "¡Riégame! ☀️🌱",
                    mensaje: "El riego de ${planta.nombre} fue registrado correctamente.",
                  );
                  if (!mounted) return;
                  setState(() {}); // Actualiza fechas en pantalla.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("¡Riego registrado correctamente! 💧")),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildBotonAccion(
                icon: Icons.wb_sunny,
                label: "Registrar horas de sol",
                color: Colors.orange,
                onPressed: () => _registrarHorasSol(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[700])),
          Text(value.isEmpty ? "Sin datos" : value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildFechaRiego(String label, DateTime fecha) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text("${fecha.day}/${fecha.month}/${fecha.year}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildBotonAccion({required IconData icon, required String label, required VoidCallback onPressed, Color? color}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: color != null ? ElevatedButton.styleFrom(backgroundColor: color.withOpacity(0.1), foregroundColor: color) : null,
        icon: Icon(icon),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}
