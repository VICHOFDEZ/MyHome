// lib/screens/emergency_profile_screen.dart
import 'package:flutter/material.dart';
import '../models/emergency_profile.dart';
import '../services/emergency_profile_storage.dart';

class EmergencyProfileScreen extends StatefulWidget {
  const EmergencyProfileScreen({super.key});

  @override
  State<EmergencyProfileScreen> createState() => _EmergencyProfileScreenState();
}

class _EmergencyProfileScreenState extends State<EmergencyProfileScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _tipoSangreController = TextEditingController();
  final _alergiasController = TextEditingController();
  final _contactoNombreController = TextEditingController();
  final _contactoTelefonoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final profile = await EmergencyProfileStorage.loadProfile();
    if (profile != null) {
      _nombreController.text = profile.nombre;
      _apellidoController.text = profile.apellido;
      _tipoSangreController.text = profile.tipoSangre;
      _alergiasController.text = profile.alergias;
      _contactoNombreController.text = profile.contactoNombre;
      _contactoTelefonoController.text = profile.contactoTelefono;
    }
  }

  Future<void> _guardar() async {
    final profile = EmergencyProfile(
      nombre: _nombreController.text,
      apellido: _apellidoController.text,
      tipoSangre: _tipoSangreController.text,
      alergias: _alergiasController.text,
      contactoNombre: _contactoNombreController.text,
      contactoTelefono: _contactoTelefonoController.text,
    );

    await EmergencyProfileStorage.saveProfile(profile);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos guardados')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos de Emergencia')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: _nombreController, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: _apellidoController, decoration: const InputDecoration(labelText: 'Apellido')),
            TextField(controller: _tipoSangreController, decoration: const InputDecoration(labelText: 'Tipo de sangre')),
            TextField(controller: _alergiasController, decoration: const InputDecoration(labelText: 'Alergias')),
            TextField(controller: _contactoNombreController, decoration: const InputDecoration(labelText: 'Contacto de emergencia')),
            TextField(controller: _contactoTelefonoController, decoration: const InputDecoration(labelText: 'Teléfono de contacto')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardar,
              child: const Text('Guardar datos'),
            ),
          ],
        ),
      ),
    );
  }
}
