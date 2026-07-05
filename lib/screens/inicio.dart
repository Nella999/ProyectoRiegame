import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //Agregando imports
import '../models/planta.dart';
import '../viewmodels/planta_viewmodel.dart';
import 'registrar_planta.dart'; // import para registrar
import '../widgets/planta_card.dart';
import 'detalle_planta.dart';
import '../widgets/bienvenida_card.dart';
import '../widgets/estadisticas_card.dart';


class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}
class _InicioState extends State<Inicio> {
  final PlantaViewModel viewModel = PlantaViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("¡Riégame!"),
      ),

      body: Column(
        children: [
          const BienvenidaCard(),
          EstadisticasCard(
            viewModel: viewModel,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _buildListaPlantas(),
          ),
        ],
      ),
      floatingActionButton: _buildBotonAgregar(context),
    );
  }
  Widget _buildListaPlantas() { //Creando lista de plantas
    return StreamBuilder<QuerySnapshot>(
      stream: viewModel.obtenerPlantas(),
      builder: (context, snapshot) {

        if (snapshot.hasError) {
          return const Center(
            child: Text("Ocurrió un error"),
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final plantas = snapshot.data!.docs;
        if (plantas.isEmpty) {
          return const Center(
            child: Text(
              "Aún no registraste ninguna planta 🌱",
            ),
          );
        }
        return ListView.builder(
          itemCount: plantas.length,
          itemBuilder: (context, index) {
            final planta = Planta.fromMap(
              plantas[index].data()
              as Map<String, dynamic>,
            );
            return PlantaCard(
              planta: planta,
                onDelete: () async { //confirmación de eliminar
                  final confirmar = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Eliminar planta"),
                        content: Text(
                          "¿Deseas eliminar '${planta.nombre}'?\n\nEsta acción no se puede deshacer.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text("Eliminar"),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirmar == true) {
                    await viewModel.eliminarPlanta(planta.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${planta.nombre} fue eliminada.",
                        ),
                      ),
                    );
                  }
                },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetallePlanta(
                      planta: planta,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );

  }
  Widget _buildBotonAgregar(BuildContext context) { // Botón para registrar planta
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
            const RegistrarPlanta(),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}