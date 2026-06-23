import 'package:flutter/material.dart';
import 'screens/inicio.dart';

void main() {
  runApp(const RiegameApp());
}

class RiegameApp extends StatelessWidget {
  const RiegameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '¡Riégame!',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const Inicio(),
    );
  }
}