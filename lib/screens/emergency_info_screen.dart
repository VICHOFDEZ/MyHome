// lib/screens/emergency_info_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../models/emergency_profile.dart';
import '../services/emergency_profile_storage.dart';
import 'emergency_profile_screen.dart';

// 🎨 Colores de la app (borra estas líneas si ya los tienes globales)
const kPrimaryColor = Color(0xFF1B4965);
const kSecondaryColor = Color(0xFF5FA8D3);
const kBackgroundColor = Color(0xFFF4F6FA);

class EmergencyInfoScreen extends StatefulWidget {
  const EmergencyInfoScreen({super.key});

  @override
  State<EmergencyInfoScreen> createState() => _EmergencyInfoScreenState();
}

class _EmergencyInfoScreenState extends State<EmergencyInfoScreen> {
  EmergencyProfile? profile;

  String? _direccion;
  bool _cargandoUbicacion = false;
  String? _errorUbicacion;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _cargarUbicacion();
  }

  Future<void> _loadProfile() async {
    profile = await EmergencyProfileStorage.loadProfile();
    setState(() {});
  }

  Future<void> _llamar(String numero) async {
    if (numero.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: numero);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _cargarUbicacion() async {
    setState(() {
      _cargandoUbicacion = true;
      _errorUbicacion = null;
    });

    try {
      // 1. Revisar permisos
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Servicio de ubicación desactivado.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Sin permisos de ubicación.');
      }

      // 2. Obtener coordenadas
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 3. Pasar a dirección legible
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isEmpty) {
        throw Exception('No se pudo obtener la dirección.');
      }

      final p = placemarks.first;
      final calle = p.street ?? '';
      final numero = p.subThoroughfare ?? '';
      final comuna = p.locality ?? p.subAdministrativeArea ?? '';
      final region = p.administrativeArea ?? '';

      final direccion = [
        calle.isNotEmpty ? calle : null,
        numero.isNotEmpty ? numero : null,
      ].whereType<String>().join(' ');

      final detalle = [
        comuna.isNotEmpty ? comuna : null,
        region.isNotEmpty ? region : null,
      ].whereType<String>().join(', ');

      setState(() {
        _direccion = detalle.isEmpty ? direccion : '$direccion\n$detalle';
        _cargandoUbicacion = false;
      });
    } catch (e) {
      setState(() {
        _cargandoUbicacion = false;
        _errorUbicacion =
            'No se pudo obtener tu ubicación. Revisa los permisos o tu conexión.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileLocal = profile;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: kPrimaryColor),
        title: const Text(
          'Botón de Pánico',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: profileLocal == null
          ? const Center(child: Text('Aún no has registrado tus datos'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),

                  // 🔴 BOTÓN CARABINEROS
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _llamar('133'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(260, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'Llamar a Carabineros (133)',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 📞 BOTÓN CONTACTO DE EMERGENCIA
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _llamar(profileLocal.contactoTelefono),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: kPrimaryColor,
                        minimumSize: const Size(260, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: kSecondaryColor),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Llamar a ${profileLocal.contactoNombre}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 🧾 DATOS DEL PERFIL
                  const Text(
                    'Tus Datos',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Nombre: ${profileLocal.nombre} ${profileLocal.apellido}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Tipo de sangre: ${profileLocal.tipoSangre}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Alergias: ${profileLocal.alergias}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmergencyProfileScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Editar mis datos de emergencia',
                      style: TextStyle(
                        color: kPrimaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 📍 UBICACIÓN
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tu ubicación actual:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildLocationCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildLocationCard() {
    if (_cargandoUbicacion) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: const [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('Buscando tu ubicación...'),
            ],
          ),
        ),
      );
    }

    if (_errorUbicacion != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.location_off, color: Colors.redAccent),
              const SizedBox(width: 8),
              Expanded(child: Text(_errorUbicacion!)),
            ],
          ),
        ),
      );
    }

    if (_direccion == null) {
      return const Text(
        'No se pudo determinar tu ubicación.',
        style: TextStyle(fontSize: 13),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_on, color: kSecondaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _direccion!,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}