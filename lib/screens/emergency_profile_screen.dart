// lib/screens/emergency_profile_screen.dart
import 'package:flutter/material.dart';
import '../models/emergency_profile.dart';
import '../services/emergency_profile_storage.dart';

// 🎨 Colores (opcional, si ya los tienes en otro lado, usa ese import)
const kPrimaryColor = Color(0xFF1B4965);
const kSecondaryColor = Color(0xFF5FA8D3);
const kBackgroundColor = Color(0xFFF4F6FA);

class EmergencyProfileScreen extends StatefulWidget {
  const EmergencyProfileScreen({super.key});

  @override
  State<EmergencyProfileScreen> createState() =>
      _EmergencyProfileScreenState();
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
      setState(() {});
    }
  }

  Future<void> _guardar() async {
    final profile = EmergencyProfile(
      nombre: _nombreController.text.trim(),
      apellido: _apellidoController.text.trim(),
      tipoSangre: _tipoSangreController.text.trim(),
      alergias: _alergiasController.text.trim(),
      contactoNombre: _contactoNombreController.text.trim(),
      contactoTelefono: _contactoTelefonoController.text.trim(),
    );

    await EmergencyProfileStorage.saveProfile(profile);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos guardados')),
    );
    Navigator.pop(context); // opcional: volver atrás después de guardar
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

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
          'Datos de Emergencia',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 4),
            _buildField(
              controller: _nombreController,
              label: 'Nombre',
            ),
            _buildField(
              controller: _apellidoController,
              label: 'Apellido',
            ),
            _buildField(
              controller: _tipoSangreController,
              label: 'Tipo de sangre',
            ),
            _buildField(
              controller: _alergiasController,
              label: 'Alergias',
            ),
            const SizedBox(height: 8),
            const Text(
              'Contacto de emergencia',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            _buildField(
              controller: _contactoNombreController,
              label: 'Nombre del contacto',
            ),
            _buildField(
              controller: _contactoTelefonoController,
              label: 'Teléfono de contacto',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),

            // Botón guardar grande y centrado
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: kPrimaryColor,
                  elevation: 2,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: kSecondaryColor),
                  ),
                ),
                child: const Text(
                  'Guardar datos',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
