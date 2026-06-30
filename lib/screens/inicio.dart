import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //Agregando imports
import '../models/planta.dart';
import '../services/firestore_service.dart'; // import para llamar a los servicios de firestore
import 'registrar_planta.dart'; // import para registrar
import 'editar_planta.dart'; // import para poder editar

class Inicio extends StatelessWidget {
  Inicio({super.key});
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("¡Riégame!"),
      ),

      // Cuerpo pantalla
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.obtenerPlantas(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return const Center(
              child: Text("Ocurrió un error :("),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final plantas = snapshot.data!.docs;
          if (plantas.isEmpty) {
            return const Center(
              child: Text(
                "Aún no registraste ninguna planta 🌱",
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          //Se agrega automaticamente la planta dps de guardarse
          return ListView.builder(
            itemCount: plantas.length,
            itemBuilder: (context, index) {
              final planta = Planta.fromMap(
                plantas[index].data() as Map<String, dynamic>,
              );
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(

                  // para redirigir a editar_planta
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditarPlanta(
                          planta: planta,
                        ),
                      ),
                    );
                  },

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
                    onPressed: () async {
                      await firestoreService.eliminarPlanta(planta.id);
                    },
                  ),
                ),
              );
            },
          );
        },
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