import 'package:flutter/material.dart';

class TechniciansScreen extends StatelessWidget {
  const TechniciansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Técnicos y Ayudas Rápidas"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección 1: técnicos cercanos
          Card(
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.engineering, color: Colors.blue),
              title: const Text("Contactar técnico cercano"),
              subtitle: const Text("Busca técnicos cerca de tu ubicación"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/nearbyTechnicians');
              },
            ),
          ),
          const SizedBox(height: 16),

          // Sección 2: ayudas rápidas
          Card(
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.lightbulb, color: Colors.orange),
              title: const Text("Ayudas rápidas"),
              subtitle: const Text("Guías con pasos y videos explicativos"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/quickHelp');
              },
            ),
          ),
        ],
      ),
    );
  }
}
