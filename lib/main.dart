import 'package:flutter/material.dart';

void main() {
  runApp(const Riegame());
}

class Riegame extends StatelessWidget {
  const Riegame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '¡Riégame! 🌱',
      theme: ThemeData(
        colorSchemeSeed: Colors.lime,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("¡Riégame!"),
      ),
      body: const Center(
        child: Text(
          "Bienvenido a ¡Riégame!",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}