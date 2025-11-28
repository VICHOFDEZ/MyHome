// lib/screens/vias_reversibles_map_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/via_reversible.dart';

// 🎨 Quita estas constantes si ya las tienes en un archivo de tema global
const kPrimaryColor = Color(0xFF1B4965);
const kSecondaryColor = Color(0xFF5FA8D3);
const kBackgroundColor = Color(0xFFF4F6FA);

class ViasReversiblesMapScreen extends StatefulWidget {
  const ViasReversiblesMapScreen({super.key});

  @override
  State<ViasReversiblesMapScreen> createState() =>
      _ViasReversiblesMapScreenState();
}

class _ViasReversiblesMapScreenState extends State<ViasReversiblesMapScreen> {
  ViaReversible? _viaSeleccionada;

  @override
  Widget build(BuildContext context) {
    // ---- POLYLINES (líneas de las calles) ----
    final polylines = <Polyline>{};

    for (final via in viasReversibles) {
      // Necesitamos mínimo 2 puntos para dibujar una línea
      if (via.puntosMapa.length < 2) continue;

      final bool isSelected = _viaSeleccionada?.nombre == via.nombre;

      polylines.add(
        Polyline(
          polylineId: PolylineId(via.nombre),
          points: via.puntosMapa,
          width: isSelected ? 8 : 6,
          color: isSelected
              ? kSecondaryColor                         // resaltada
              : kPrimaryColor.withValues(alpha: 0.85),         // resto de vías
          consumeTapEvents: true,
          zIndex: isSelected ? 2 : 1,
          onTap: () {
            setState(() {
              _viaSeleccionada = via;
            });
          },
        ),
      );
    }

    const centroRM = LatLng(-33.45, -70.65); // Centro aprox de Santiago

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: kPrimaryColor),
        title: const Text(
          'Vías reversibles',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: centroRM,
              zoom: 11,
            ),
            polylines: polylines,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            onTap: (_) {
              // Tocar el mapa fuera de una vía cierra el panel
              setState(() {
                _viaSeleccionada = null;
              });
            },
          ),

          // Panel con la info de la vía tocada
          if (_viaSeleccionada != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomPanel(context, _viaSeleccionada!),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context, ViaReversible via) {
    String formatTime(TimeOfDay t) =>
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                via.nombre,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                via.comuna,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              if (via.tramo.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Tramo: ${via.tramo}',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
              const SizedBox(height: 10),
              const Divider(height: 1),

              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.wb_sunny, size: 18, color: kSecondaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Mañana: ${formatTime(via.amInicio)} – ${formatTime(via.amFin)}\n'
                      'Sentido: ${via.amSentido}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.nights_stay,
                      size: 18, color: kSecondaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tarde: ${formatTime(via.pmInicio)} – ${formatTime(via.pmFin)}\n'
                      'Sentido: ${via.pmSentido}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Toca el mapa para cerrar',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
