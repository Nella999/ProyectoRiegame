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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("¡Riégame!"),
      ),

      body: Column(
        children: [
          Card( // Tarjeta de bienvenida
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
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
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
          ),
          Expanded(
            child: _buildListaPlantas(),
          ),
        ],
      ),
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