import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //Agregando imports
import '../models/planta.dart';
import '../viewmodels/planta_viewmodel.dart';
import 'registrar_planta.dart'; // import para registrar
import 'editar_planta.dart'; // import para poder editar
import '../widgets/planta_card.dart';
import 'detalle_planta.dart';


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

      body: _buildListaPlantas(),

      floatingActionButton: _buildBotonAgregar(context),
    );
  }

  @override
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
              onDelete: () async {
                await viewModel.eliminarPlanta(
                  planta.id,
                );
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
  Widget _buildBotonAgregar(BuildContext context) { // Borón para registrar planta
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