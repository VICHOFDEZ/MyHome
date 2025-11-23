import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class ZonasPeligrosasScreen extends StatefulWidget {
  const ZonasPeligrosasScreen({Key? key}) : super(key: key);

  @override
  State<ZonasPeligrosasScreen> createState() => _ZonasPeligrosasScreenState();
}

class _ZonasPeligrosasScreenState extends State<ZonasPeligrosasScreen> {
  late GoogleMapController mapController;
  final TextEditingController _searchController = TextEditingController();

  final LatLng _center = const LatLng(-33.45, -70.6667);
  Map<String, dynamic>? comunaSeleccionada;

  // Lista de comunas y riesgos (igual que antes)
  final List<Map<String, dynamic>> comunasRiesgo = [
    {'nombre': 'Santiago', 'nivel': 'alto', 'lat': -33.45, 'lng': -70.6667, 'detalle': 'Alta concentración de delitos y tráfico en zonas céntricas.'},
    {'nombre': 'Puente Alto', 'nivel': 'alto', 'lat': -33.6117, 'lng': -70.5750, 'detalle': 'Alta tasa de robos y microtráfico.'},
    {'nombre': 'La Pintana', 'nivel': 'alto', 'lat': -33.5833, 'lng': -70.6333, 'detalle': 'Problemas de narcotráfico y delincuencia organizada.'},
    {'nombre': 'El Bosque', 'nivel': 'alto', 'lat': -33.5667, 'lng': -70.6833, 'detalle': 'Zonas con alta vulnerabilidad social.'},
    {'nombre': 'San Ramón', 'nivel': 'alto', 'lat': -33.55, 'lng': -70.6333, 'detalle': 'Presencia de bandas y delitos violentos.'},
    {'nombre': 'Lo Espejo', 'nivel': 'alto', 'lat': -33.5333, 'lng': -70.7, 'detalle': 'Alta tasa de robos con violencia.'},
    {'nombre': 'Cerro Navia', 'nivel': 'alto', 'lat': -33.4333, 'lng': -70.7333, 'detalle': 'Delitos frecuentes en áreas residenciales.'},
    {'nombre': 'Renca', 'nivel': 'alto', 'lat': -33.3833, 'lng': -70.7167, 'detalle': 'Riesgo elevado en sectores periféricos.'},
    {'nombre': 'La Granja', 'nivel': 'alto', 'lat': -33.55, 'lng': -70.6167, 'detalle': 'Frecuentes delitos de oportunidad.'},
    {'nombre': 'Quilicura', 'nivel': 'alto', 'lat': -33.3669, 'lng': -70.7286, 'detalle': 'Problemas de seguridad en áreas industriales.'},
    {'nombre': 'San Joaquín', 'nivel': 'alto', 'lat': -33.485, 'lng': -70.627, 'detalle': 'Zona de tránsito con robos ocasionales.'},
    {'nombre': 'Pedro Aguirre Cerda', 'nivel': 'alto', 'lat': -33.5, 'lng': -70.6667, 'detalle': 'Presencia de delitos menores y medianos.'},

    // Riesgo medio
    {'nombre': 'San Bernardo', 'nivel': 'medio', 'lat': -33.5933, 'lng': -70.7028, 'detalle': 'Riesgo variable según el sector.'},
    {'nombre': 'Maipú', 'nivel': 'medio', 'lat': -33.5095, 'lng': -70.7569, 'detalle': 'Riesgo moderado en sectores comerciales.'},
    {'nombre': 'Pudahuel', 'nivel': 'medio', 'lat': -33.4484, 'lng': -70.7544, 'detalle': 'Cuidado en áreas industriales.'},
    {'nombre': 'Estación Central', 'nivel': 'medio', 'lat': -33.45, 'lng': -70.7, 'detalle': 'Zona de tránsito con robos frecuentes.'},
    {'nombre': 'La Cisterna', 'nivel': 'medio', 'lat': -33.5333, 'lng': -70.6667, 'detalle': 'Riesgo moderado en plazas y transporte.'},
    {'nombre': 'Lo Prado', 'nivel': 'medio', 'lat': -33.45, 'lng': -70.7167, 'detalle': 'Incidentes ocasionales en barrios específicos.'},
    {'nombre': 'San Miguel', 'nivel': 'medio', 'lat': -33.4833, 'lng': -70.65, 'detalle': 'Riesgo medio por cercanía al centro.'},
    {'nombre': 'Independencia', 'nivel': 'medio', 'lat': -33.417, 'lng': -70.65, 'detalle': 'Tránsito y comercio con riesgo intermedio.'},
    {'nombre': 'Recoleta', 'nivel': 'medio', 'lat': -33.4042, 'lng': -70.6420, 'detalle': 'Delitos menores en zonas céntricas.'},
    {'nombre': 'Macul', 'nivel': 'medio', 'lat': -33.478, 'lng': -70.598, 'detalle': 'Comuna residencial con riesgo variable.'},
    {'nombre': 'La Florida', 'nivel': 'medio', 'lat': -33.55, 'lng': -70.583, 'detalle': 'Riesgo medio en áreas cercanas a autopistas.'},
    {'nombre': 'Peñalolén', 'nivel': 'medio', 'lat': -33.484, 'lng': -70.541, 'detalle': 'Sectores residenciales con delitos ocasionales.'},
    {'nombre': 'San Joaquín', 'nivel': 'medio', 'lat': -33.485, 'lng': -70.627, 'detalle': 'Riesgo intermedio, principalmente en transporte.'},
    {'nombre': 'Conchalí', 'nivel': 'medio', 'lat': -33.383, 'lng': -70.666, 'detalle': 'Zonas mixtas, con seguridad variable.'},
    {'nombre': 'Huechuraba', 'nivel': 'medio', 'lat': -33.3667, 'lng': -70.65, 'detalle': 'Riesgo medio en sectores residenciales.'},
    {'nombre': 'La Reina', 'nivel': 'medio', 'lat': -33.441, 'lng': -70.553, 'detalle': 'Zonas seguras, pero con incidentes aislados.'},
    {'nombre': 'San José de Maipo', 'nivel': 'medio', 'lat': -33.65, 'lng': -70.3667, 'detalle': 'Riesgo bajo en áreas rurales, moderado en turismo.'},
    {'nombre': 'El Monte', 'nivel': 'medio', 'lat': -33.683, 'lng': -70.983, 'detalle': 'Zonas rurales con seguridad variable.'},
    {'nombre': 'Padre Hurtado', 'nivel': 'medio', 'lat': -33.57, 'lng': -70.815, 'detalle': 'Delitos ocasionales en áreas periféricas.'},
    {'nombre': 'Melipilla', 'nivel': 'medio', 'lat': -33.7, 'lng': -71.216, 'detalle': 'Comuna extensa con áreas seguras y otras conflictivas.'},
    {'nombre': 'Talagante', 'nivel': 'medio', 'lat': -33.666, 'lng': -70.933, 'detalle': 'Comuna en crecimiento con riesgo moderado.'},
    {'nombre': 'Buin', 'nivel': 'medio', 'lat': -33.7333, 'lng': -70.7333, 'detalle': 'Riesgo medio en zonas céntricas.'},
    {'nombre': 'Calera de Tango', 'nivel': 'medio', 'lat': -33.633, 'lng': -70.817, 'detalle': 'Área semi-rural con delitos aislados.'},
    {'nombre': 'Paine', 'nivel': 'medio', 'lat': -33.8167, 'lng': -70.75, 'detalle': 'Seguridad variable según el sector.'},
    {'nombre': 'Isla de Maipo', 'nivel': 'medio', 'lat': -33.754, 'lng': -70.883, 'detalle': 'Comuna tranquila con algunos delitos menores.'},
    {'nombre': 'Colina', 'nivel': 'medio', 'lat': -33.2833, 'lng': -70.6667, 'detalle': 'Aumento de delincuencia, principalmente "turbazos".'},


    // Bajo riesgo
    {'nombre': 'Ñuñoa', 'nivel': 'bajo', 'lat': -33.456, 'lng': -70.595, 'detalle': 'Comuna segura y con buena iluminación pública.'},
    {'nombre': 'Providencia', 'nivel': 'bajo', 'lat': -33.431, 'lng': -70.609, 'detalle': 'Alta vigilancia policial y baja tasa delictiva.'},
    {'nombre': 'Las Condes', 'nivel': 'bajo', 'lat': -33.405, 'lng': -70.551, 'detalle': 'Zonas residenciales seguras.'},
    {'nombre': 'Vitacura', 'nivel': 'bajo', 'lat': -33.383, 'lng': -70.556, 'detalle': 'Alta seguridad privada y orden urbano.'},
    {'nombre': 'Lo Barnechea', 'nivel': 'bajo', 'lat': -33.35, 'lng': -70.516, 'detalle': 'Bajo nivel delictivo y zonas residenciales.'},
    {'nombre': 'Lampa', 'nivel': 'bajo', 'lat': -33.2869, 'lng': -70.8753, 'detalle': 'Zonas rurales con baja criminalidad.'},
    {'nombre': 'Tiltil', 'nivel': 'bajo', 'lat': -33.1, 'lng': -70.9, 'detalle': 'Área rural con bajo riesgo.'},
    {'nombre': 'Pirque', 'nivel': 'bajo', 'lat': -33.6333, 'lng': -70.55, 'detalle': 'Zona rural con bajo índice de delitos.'},
    {'nombre': 'Curacaví', 'nivel': 'bajo', 'lat': -33.406, 'lng': -71.142, 'detalle': 'Área tranquila, entorno semi-rural.'},
    {'nombre': 'Alhué', 'nivel': 'bajo', 'lat': -34.033, 'lng': -71.083, 'detalle': 'Zona rural muy segura.'},
    {'nombre': 'San Pedro', 'nivel': 'bajo', 'lat': -33.9, 'lng': -71.466, 'detalle': 'Comuna rural y pacífica.'},
  ];

  Set<Circle> getCircles() {
    return comunasRiesgo.map((comuna) {
      Color color;
      switch (comuna['nivel']) {
        case 'alto':
          color = Colors.red.withOpacity(0.5);
          break;
        case 'medio':
          color = Colors.amber.withOpacity(0.5);
          break;
        default:
          color = Colors.green.withOpacity(0.5);
      }
      return Circle(
        circleId: CircleId(comuna['nombre']),
        center: LatLng(comuna['lat'], comuna['lng']),
        radius: 1500,
        fillColor: color,
        strokeWidth: 1,
        strokeColor: Colors.black26,
      );
    }).toSet();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Calcular distancia entre dos coordenadas (en metros)
  double _calcularDistancia(LatLng p1, LatLng p2) {
    const radioTierra = 6371000;
    double dLat = (p2.latitude - p1.latitude) * pi / 180;
    double dLon = (p2.longitude - p1.longitude) * pi / 180;
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(p1.latitude * pi / 180) *
            cos(p2.latitude * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radioTierra * c;
  }

  void _mostrarDetalleComuna(Map<String, dynamic> comuna) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comuna['nombre'],
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Nivel de riesgo: ${comuna['nivel'].toUpperCase()}",
                style: TextStyle(
                  fontSize: 18,
                  color: comuna['nivel'] == 'alto'
                      ? Colors.red
                      : comuna['nivel'] == 'medio'
                          ? Colors.orange
                          : Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              Text(comuna['detalle'], style: const TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    );
  }

  void _buscarComuna(String nombre) {
    final comuna = comunasRiesgo.firstWhere(
      (c) => c['nombre'].toLowerCase().contains(nombre.toLowerCase()),
      orElse: () => {},
    );
    if (comuna.isNotEmpty) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(comuna['lat'], comuna['lng']), 13),
      );
      _mostrarDetalleComuna(comuna);
    }
  }

  // Detectar toque en el mapa
  void _detectarToqueEnMapa(LatLng punto) {
    for (var comuna in comunasRiesgo) {
      final centro = LatLng(comuna['lat'], comuna['lng']);
      final distancia = _calcularDistancia(punto, centro);
      if (distancia < 1500) {
        _mostrarDetalleComuna(comuna);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zonas peligrosas – RM"),
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 10.5),
            circles: getCircles(),
            myLocationEnabled: true,
            onTap: _detectarToqueEnMapa, // 👈 Detecta toque en el mapa
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Buscar comuna...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.redAccent),
                ),
                onSubmitted: (value) => _buscarComuna(value),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "🔴 Alto riesgo\n🟡 Riesgo medio\n🟢 Bajo riesgo",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
