import 'package:flutter/material.dart';
import 'emergency_info_screen.dart';
import 'emergency_profile_screen.dart';
import '../services/emergency_profile_storage.dart';

/// 🎨 Paleta oficial de la app
const kPrimaryColor = Color(0xFF1B4965);
const kSecondaryColor = Color(0xFF5FA8D3);
const kBackgroundColor = Color(0xFFF4F6FA);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Bienvenido a My Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            /// TÍTULO
            const Center(
              child: Text(
                'Acceso Rápido',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// GRID PROFESIONAL
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1.2,
                children: const [
                  _HomeCard(icon: Icons.restaurant, label: 'Comida', route: '/food'),
                  _HomeCard(icon: Icons.calculate, label: 'Simulador', route: '/simulador'),
                  _HomeCard(icon: Icons.build, label: 'Mantención', route: '/technicians'),
                  _HomeCard(icon: Icons.school, label: 'Tutores', route: '/classes'),
                  _HomeCard(icon: Icons.alarm, label: 'Recordatorio', route: '/reminders'),
                  _HomeCard(icon: Icons.verified_user, label: 'Zonas Peligrosas', route: '/zonas'),
                  _HomeCard(icon: Icons.explore, label: 'Vias Reversibles', route: '/vias'),
                  _HomeCard(icon: Icons.self_improvement, label: 'Bienestar & Calma', route: '/bienestar'),
                ],
              ),
            ),
          ],
        ),
      ),

      /// BOTÓN S.O.S.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final profile = await EmergencyProfileStorage.loadProfile();

          if (profile == null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EmergencyProfileScreen()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EmergencyInfoScreen()),
            );
          }
        },
        backgroundColor: Colors.red,
        icon: const Icon(Icons.phone, color: Colors.white),
        label: const Text('S.O.S', style: TextStyle(color: Colors.white)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

/// ------------------------------
/// CARD GRANDE ESTILO UAI
/// ------------------------------
class _HomeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const _HomeCard({required this.icon, required this.label, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: kPrimaryColor),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
