import 'package:flutter/material.dart';

// 🎨 Paleta de colores de la app (ajusta si quieres)
const kPrimaryColor = Color(0xFF1B4965);      // teal oscuro
const kSecondaryColor = Color(0xFF5FA8D3);    // teal clarito
const kBackgroundColor = Color(0xFFF4F6FA);   // fondo suave

class TechniciansScreen extends StatelessWidget {
  const TechniciansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: kPrimaryColor),
        title: const Text(
          "Servicios y Guías",
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ActionTile(
            icon: Icons.engineering,
            iconColor: kPrimaryColor,
            title: "Contactar técnico cercano",
            subtitle: "Busca técnicos cerca de tu ubicación",
            onTap: () {
              Navigator.pushNamed(context, '/nearbyTechnicians');
            },
          ),
          const SizedBox(height: 16),
          _ActionTile(
            icon: Icons.lightbulb_outline,
            iconColor: Colors.amber,
            title: "Ayudas rápidas",
            subtitle: "Guías con pasos y videos explicativos",
            onTap: () {
              Navigator.pushNamed(context, '/quickHelp');
            },
          ),
        ],
      ),
    );
  }
}

// 🔹 Tile estilo Material 3 pro
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        splashColor: kSecondaryColor.withValues(alpha: 0.2),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Icono dentro de "pill" de color suave
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: kSecondaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
