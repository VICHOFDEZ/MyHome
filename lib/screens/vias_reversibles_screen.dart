import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViasReversiblesScreen extends StatefulWidget {
  const ViasReversiblesScreen({Key? key}) : super(key: key);

  @override
  State<ViasReversiblesScreen> createState() => _ViasReversiblesScreenState();
}

class _ViasReversiblesScreenState extends State<ViasReversiblesScreen> {
  late GoogleMapController mapController;
  final TextEditingController _searchController = TextEditingController();

  final LatLng _center = const LatLng(-33.45, -70.6667);

  List<Map<String, dynamic>> vias = [];
  List<Map<String, dynamic>> viasFiltradas = [];

  @override
  void initState() {
    super.initState();
    _cargarVias();
  }

  // 🔹 Cargar datos reales de vías reversibles
  void _cargarVias() {
    vias = [
      // 🔹 AM – Mañana
      {
        'nombre': 'Av. Vicuña Mackenna',
        'tramo': 'Av. Matta – Av. Departamental',
        'horario': '07:00 a 09:00 (AM)',
        'sentido': 'Norte → Sur',
        'ruta': [
          const LatLng(-33.457, -70.632),
          const LatLng(-33.496, -70.612),
        ],
      },
      {
        'nombre': 'Av. Grecia',
        'tramo': 'Av. Tobalaba – Av. Américo Vespucio',
        'horario': '07:00 a 10:00 (AM)',
        'sentido': 'Oriente → Poniente',
        'ruta': [
          const LatLng(-33.47, -70.56),
          const LatLng(-33.46, -70.60),
        ],
      },
      {
        'nombre': 'Av. Presidente Kennedy',
        'tramo': 'Manquehue – Costanera Andrés Bello',
        'horario': '07:30 a 10:00 (AM)',
        'sentido': 'Oriente → Poniente',
        'ruta': [
          const LatLng(-33.395, -70.57),
          const LatLng(-33.414, -70.60),
        ],
      },
      {
        'nombre': 'Av. Ossa',
        'tramo': 'Américo Vespucio – Av. Macul',
        'horario': '07:00 a 09:00 (AM)',
        'sentido': 'Oriente → Poniente',
        'ruta': [
          const LatLng(-33.482, -70.595),
          const LatLng(-33.48, -70.61),
        ],
      },
      {
        'nombre': 'Av. Recoleta',
        'tramo': 'Av. Dorsal – Av. Santos Dumont',
        'horario': '07:00 a 09:30 (AM)',
        'sentido': 'Norte → Sur',
        'ruta': [
          const LatLng(-33.395, -70.64),
          const LatLng(-33.422, -70.64),
        ],
      },
      {
        'nombre': 'Av. Santa Rosa',
        'tramo': 'Departamental – Matta',
        'horario': '07:00 a 09:00 (AM)',
        'sentido': 'Sur → Norte',
        'ruta': [
          const LatLng(-33.496, -70.634),
          const LatLng(-33.45, -70.64),
        ],
      },
      {
        'nombre': 'Av. Américo Vespucio Norte',
        'tramo': 'Ruta 68 – Panamericana Norte',
        'horario': '06:30 a 09:00 (AM)',
        'sentido': 'Poniente → Oriente',
        'ruta': [
          const LatLng(-33.435, -70.764),
          const LatLng(-33.389, -70.662),
        ],
      },
      {
        'nombre': 'Av. Irarrázaval',
        'tramo': 'Av. Los Leones – Av. Vicuña Mackenna',
        'horario': '07:00 a 10:00 (AM)',
        'sentido': 'Oriente → Poniente',
        'ruta': [
          const LatLng(-33.445, -70.60),
          const LatLng(-33.45, -70.63),
        ],
      },
      {
        'nombre': 'Av. Providencia',
        'tramo': 'Av. Tobalaba – Puente del Arzobispo',
        'horario': '07:00 a 09:00 (AM)',
        'sentido': 'Oriente → Poniente',
        'ruta': [
          const LatLng(-33.425, -70.57),
          const LatLng(-33.43, -70.62),
        ],
      },
      {
        'nombre': 'Av. Apoquindo',
        'tramo': 'Manquehue – El Bosque',
        'horario': '07:00 a 09:00 (AM)',
        'sentido': 'Oriente → Poniente',
        'ruta': [
          const LatLng(-33.408, -70.56),
          const LatLng(-33.414, -70.58),
        ],
      },
      {
        'nombre': 'Av. Tobalaba',
        'tramo': 'Av. Quilín – Av. Grecia',
        'horario': '07:00 a 09:00 (AM)',
        'sentido': 'Sur → Norte',
        'ruta': [
          const LatLng(-33.51, -70.57),
          const LatLng(-33.47, -70.57),
        ],
      },

      // 🔸 PM – Tarde
      {
        'nombre': 'Av. Grecia (PM)',
        'tramo': 'Av. Américo Vespucio – Av. Tobalaba',
        'horario': '17:00 a 21:00 (PM)',
        'sentido': 'Poniente → Oriente',
        'ruta': [
          const LatLng(-33.46, -70.60),
          const LatLng(-33.47, -70.56),
        ],
      },
      {
        'nombre': 'Av. Presidente Kennedy (PM)',
        'tramo': 'Costanera Andrés Bello – Manquehue',
        'horario': '17:00 a 20:00 (PM)',
        'sentido': 'Poniente → Oriente',
        'ruta': [
          const LatLng(-33.414, -70.60),
          const LatLng(-33.395, -70.57),
        ],
      },
      {
        'nombre': 'Av. Apoquindo (PM)',
        'tramo': 'El Bosque – Manquehue',
        'horario': '17:00 a 20:00 (PM)',
        'sentido': 'Poniente → Oriente',
        'ruta': [
          const LatLng(-33.414, -70.58),
          const LatLng(-33.408, -70.56),
        ],
      },
      {
        'nombre': 'Av. Irarrázaval (PM)',
        'tramo': 'Vicuña Mackenna – Los Leones',
        'horario': '17:30 a 21:00 (PM)',
        'sentido': 'Poniente → Oriente',
        'ruta': [
          const LatLng(-33.45, -70.63),
          const LatLng(-33.445, -70.60),
        ],
      },
      {
        'nombre': 'Av. Santa Rosa (PM)',
        'tramo': 'Matta – Departamental',
        'horario': '17:00 a 20:00 (PM)',
        'sentido': 'Norte → Sur',
        'ruta': [
          const LatLng(-33.45, -70.64),
          const LatLng(-33.496, -70.634),
        ],
      },
      {
        'nombre': 'Av. Recoleta (PM)',
        'tramo': 'Santos Dumont – Dorsal',
        'horario': '17:00 a 20:00 (PM)',
        'sentido': 'Sur → Norte',
        'ruta': [
          const LatLng(-33.422, -70.64),
          const LatLng(-33.395, -70.64),
        ],
      },
      {
        'nombre': 'Av. San Pablo',
        'tramo': 'Av. Matucana – Av. Neptuno',
        'horario': '07:00 a 10:00 (AM) / 17:00 a 20:00 (PM)',
        'sentido': 'Variable según horario',
        'ruta': [
          const LatLng(-33.44, -70.67),
          const LatLng(-33.44, -70.71),
        ],
      },
    ];

    viasFiltradas = List.from(vias);
  }

  void _buscarVia(String query) {
    setState(() {
      viasFiltradas = vias
          .where((v) =>
              v['nombre'].toLowerCase().contains(query.toLowerCase()) ||
              v['tramo'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _mostrarDetalles(Map<String, dynamic> via) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(via['nombre'],
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('🗺️ Tramo: ${via['tramo']}'),
            Text('🕖 Horario: ${via['horario']}'),
            Text('➡️ Sentido: ${via['sentido']}'),
          ],
        ),
      ),
    );
  }

  Set<Polyline> _crearPolylines() {
    Set<Polyline> polylines = {};
    for (var i = 0; i < vias.length; i++) {
      bool esPM = vias[i]['horario'].toString().contains('(PM)');
      polylines.add(
        Polyline(
          polylineId: PolylineId(vias[i]['nombre']),
          points: List<LatLng>.from(vias[i]['ruta']),
          color: esPM ? Colors.orange : Colors.blue,
          width: 5,
          consumeTapEvents: true,
          onTap: () => _mostrarDetalles(vias[i]),
        ),
      );
    }
    return polylines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vías Reversibles – RM"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        children: [
          // 🗺️ MAPA
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: GoogleMap(
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition:
                  CameraPosition(target: _center, zoom: 11),
              polylines: _crearPolylines(),
              myLocationEnabled: true,
            ),
          ),

          // 🔍 BUSCADOR
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Buscar calle o comuna...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _buscarVia,
            ),
          ),

          // 📋 LISTA
          Expanded(
            child: ListView.builder(
              itemCount: viasFiltradas.length,
              itemBuilder: (context, index) {
                final via = viasFiltradas[index];
                return Card(
                  child: ListTile(
                    title: Text(via['nombre']),
                    subtitle: Text(
                        "Tramo: ${via['tramo']}\nHorario: ${via['horario']} – Sentido: ${via['sentido']}"),
                    trailing: const Icon(Icons.directions),
                    onTap: () {
                      mapController.animateCamera(
                        CameraUpdate.newLatLngBounds(
                          LatLngBounds(
                            southwest: via['ruta'].first,
                            northeast: via['ruta'].last,
                          ),
                          100,
                        ),
                      );
                      _mostrarDetalles(via);
                    },
                  ),
                );
              },
            ),
          ),

          // 📍 LEYENDA
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.line_axis, color: Colors.blue),
                SizedBox(width: 5),
                Text("🟦 AM – Sentido hacia el centro   "),
                Icon(Icons.line_axis, color: Colors.orange),
                SizedBox(width: 5),
                Text("🟧 PM – Sentido hacia periferia"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
