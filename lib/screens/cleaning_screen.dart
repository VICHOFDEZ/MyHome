import 'package:flutter/material.dart';

class CleaningScreen extends StatelessWidget {
  const CleaningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Limpieza'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          'Aquí podrás solicitar servicios de limpieza.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
