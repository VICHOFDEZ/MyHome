import 'package:flutter/material.dart';
import 'emergency_info_screen.dart';
import 'emergency_profile_screen.dart';
import '../services/emergency_profile_storage.dart';



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
                  _QuickAccessButton(icon: Icons.calculate, label: 'Simulador'),
                  _QuickAccessButton(icon: Icons.build, label: 'Mantención'),
                  _QuickAccessButton(icon: Icons.school, label: 'Tutores'),
                  _QuickAccessButton(icon: Icons.alarm, label: 'Recordatorio'),
                  _QuickAccessButton(icon: Icons.verified_user, label: 'Zonas Peligrosas'),
                  _QuickAccessButton(icon: Icons.explore, label: 'Vias Reversibles'),
                  _QuickAccessButton(icon: Icons.self_improvement, label: 'Bienestar & Calma'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
         // 1. Cargamos el perfil desde SharedPreferences
          final profile = await EmergencyProfileStorage.loadProfile();

         // 2. Si NO hay datos -> mandamos a registrar datos
          if (profile == null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const EmergencyProfileScreen(),
              ),
            );
          } else {
            // 3. Si SÍ hay datos -> vamos al botón de pánico
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const EmergencyInfoScreen(),
              ),
            );
          }
        },
        backgroundColor: Colors.red,
        icon: const Icon(Icons.phone, color: Colors.white),
        label: const Text(
          'S.O.S',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
            Navigator.pushNamed(context, '/simulador');
            break;
          case 'Zonas Peligrosas':
            Navigator.pushNamed(context, '/zonas');
            break;
          case 'Vias Reversibles':
            Navigator.pushNamed(context, '/vias');
            break;
          case 'Bienestar & Calma':
            Navigator.pushNamed(context, '/bienestar');
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
