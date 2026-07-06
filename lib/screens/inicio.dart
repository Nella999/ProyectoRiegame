import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/planta.dart';
import '../viewmodels/planta_viewmodel.dart';
import 'registrar_planta.dart';
import '../widgets/planta_card.dart';
import 'detalle_planta.dart';
import '../widgets/bienvenida_card.dart';
import '../widgets/estadisticas_card.dart';
import 'consulta_ia.dart';

//Pantalla principal de la aplicación.
class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  // Instancia del ViewModel para gestionar la lógica de las plantas.
  final PlantaViewModel viewModel = PlantaViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("¡Riégame!"),
        actions: [
          // Botón para navegar a la consulta IA
          IconButton(
            icon: const Icon(Icons.smart_toy),
            tooltip: "Consultar IA",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ConsultaIA(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card de bienvenida.
            const BienvenidaCard(),
            // Card que muestra métricas globales
            EstadisticasCard(
              viewModel: viewModel,
            ),
            const SizedBox(height: 15),
            // Sección de la lista de plantas.
            _buildListaPlantas(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      // Botón flotante para registrar nuevas plantas.
      floatingActionButton: _buildBotonAgregar(context),
    );
  }

  //Construye la lista de plantas escuchando los cambios en Firestore en tiempo real.
  Widget _buildListaPlantas() {
    return StreamBuilder<QuerySnapshot>(
      stream: viewModel.obtenerPlantas(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Ocurrió un error al cargar las plantas"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final plantasDocs = snapshot.data!.docs;
        if (plantasDocs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Aún no registraste ninguna planta 🌱", textAlign: TextAlign.center),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: plantasDocs.length,
          itemBuilder: (context, index) {
            // De documento Firestore a modelo Planta.
            final planta = Planta.fromMap(
              plantasDocs[index].data() as Map<String, dynamic>,
            );

            return PlantaCard(
              planta: planta,
              // Lógica para eliminar una planta con confirmación previa.
              onDelete: () async {
                final confirmar = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Eliminar planta"),
                      content: Text(
                        "¿Deseas eliminar '${planta.nombre}'?\n\nEsta acción borrará todos sus riegos y registros.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Eliminar"),
                        ),
                      ],
                    );
                  },
                );

                if (confirmar == true) {
                  await viewModel.eliminarPlanta(planta.id);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${planta.nombre} fue eliminada.")),
                  );
                }
              },
              // Navegación al detalle de la planta al tocar el card.
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetallePlanta(planta: planta),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  //Construye el botón flotante de agregar.
  Widget _buildBotonAgregar(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RegistrarPlanta()),
        );
      },
      tooltip: "Agregar nueva planta",
      child: const Icon(Icons.add),
    );
  }
}
