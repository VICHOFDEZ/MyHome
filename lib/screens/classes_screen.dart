import 'package:flutter/material.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clases Disponibles'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text('Aquí estarán las clases disponibles.'),
      ),
    );
  }
}
