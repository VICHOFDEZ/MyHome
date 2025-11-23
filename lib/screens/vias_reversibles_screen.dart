// lib/screens/vias_reversibles_map_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/via_reversible.dart';

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

      polylines.add(
        Polyline(
          polylineId: PolylineId(via.nombre),
          points: via.puntosMapa,
          width: 6,
          color: Colors.blue,
          consumeTapEvents: true,
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
      appBar: AppBar(
        title: const Text('Vías reversibles'),
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

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              via.nombre,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(via.comuna, style: const TextStyle(fontSize: 13)),
            if (via.tramo.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Tramo: ${via.tramo}',
                style: const TextStyle(fontSize: 13),
              ),
            ],
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.wb_sunny, size: 18),
                const SizedBox(width: 6),
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
                const Icon(Icons.nights_stay, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Tarde: ${formatTime(via.pmInicio)} – ${formatTime(via.pmFin)}\n'
                    'Sentido: ${via.pmSentido}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
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
    );
  }
}
