import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Bienvenido a My Home',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'Acceso Rápido',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 30),

            // 🔽 Botones principales (solo visual, aún sin funcionalidad)
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _QuickAccessButton(icon: Icons.restaurant, label: 'Comida'),
                  _QuickAccessButton(icon: Icons.cleaning_services, label: 'Limpieza'),
                  _QuickAccessButton(icon: Icons.build, label: 'Mantención'),
                  _QuickAccessButton(icon: Icons.school, label: 'Tutores'),
                  _QuickAccessButton(icon: Icons.alarm, label: 'Recordatorio'),
                  _QuickAccessButton(icon: Icons.verified_user, label: 'Zonas Peligrosas'),
                  _QuickAccessButton(icon: Icons.explore, label: 'Vias Reversibles'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickAccessButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (label) {
          case 'Recordatorio':
            Navigator.pushNamed(context, '/reminders');
            break;
          case 'Tutores':
            Navigator.pushNamed(context, '/classes');
            break;
          case 'Mantención':
            Navigator.pushNamed(context, '/technicians');
            break;
          case 'Comida':
            Navigator.pushNamed(context, '/food');
            break;
          case 'Limpieza':
            Navigator.pushNamed(context, '/cleaning');
            break;
          case 'Zonas Peligrosas':
            Navigator.pushNamed(context, '/zonas');
            break;
          case 'Vias Reversibles':
            Navigator.pushNamed(context, '/vias');
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Función "$label" aún no disponible')),
            );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.teal[700]),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.teal[800],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
