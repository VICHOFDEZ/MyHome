// lib/screens/emergency_info_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/emergency_profile.dart';
import '../services/emergency_profile_storage.dart';
import 'emergency_profile_screen.dart';


class EmergencyInfoScreen extends StatefulWidget {
  const EmergencyInfoScreen({super.key});

  @override
  State<EmergencyInfoScreen> createState() => _EmergencyInfoScreenState();
}

class _EmergencyInfoScreenState extends State<EmergencyInfoScreen> {
  EmergencyProfile? profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    profile = await EmergencyProfileStorage.loadProfile();
    setState(() {});
  }

  Future<void> _llamar(String numero) async {
    final uri = Uri(scheme: 'tel', path: numero);
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Botón de Pánico')),
      body: profile == null
          ? const Center(child: Text('Aún no has registrado tus datos'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _llamar('133'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Llamar a Carabineros (133)'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _llamar(profile!.contactoTelefono),
                    child: Text('Llamar a ${profile!.contactoNombre}'),
                  ),
                  const SizedBox(height: 30),
                  const Text('Tus Datos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('Nombre: ${profile!.nombre} ${profile!.apellido}'),
                  Text('Tipo de sangre: ${profile!.tipoSangre}'),
                  Text('Alergias: ${profile!.alergias}'),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmergencyProfileScreen(),
                        ),
                      );
                    },
                    child: const Text('Editar mis datos de emergencia'),
                  ),
                  const SizedBox(height: 30),
                  const Text('Aquí luego pondremos tu ubicación 👇'),
                ],
              ),
            ),
    );
  }
}
