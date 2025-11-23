import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final String apiKey = 'AIzaSyB0nC__AJm9rMkS3huOeaXeMgx4tA2KgcQ';
  List<Map<String, dynamic>> restaurants = [];
  bool isLoading = false;
  bool gpsFailed = false;
  TextEditingController comunaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    setState(() {
      isLoading = true;
      gpsFailed = false;
    });

    Position? position;

    try {
      // 🛰️ Intentar usar GPS
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Permiso denegado');
      }

      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (_) {
      // 🚫 GPS falló → permitir escribir comuna
      setState(() {
        gpsFailed = true;
        isLoading = false;
      });
      return;
    }

    await _loadNearbyPlaces(position!.latitude, position.longitude);
  }

  Future<void> _loadNearbyPlaces(double lat, double lng) async {
    setState(() => isLoading = true);

    final nearbyUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$lat,$lng'
        '&radius=2000'
        '&type=restaurant'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(nearbyUrl));
    final data = json.decode(response.body);

    if (data['results'] == null) {
      setState(() {
        restaurants = [];
        isLoading = false;
      });
      return;
    }

    List<Map<String, dynamic>> fetched = [];

    for (var r in data['results']) {
      fetched.add({
        'name': r['name'] ?? 'Sin nombre',
        'rating': r['rating']?.toString() ?? 'N/A',
        'lat': r['geometry']['location']['lat'],
        'lng': r['geometry']['location']['lng'],
        'place_id': r['place_id'],
      });
    }

    // 🔹 Obtener teléfonos y calcular distancia
    for (var resto in fetched) {
      final detailsUrl =
          'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=${resto['place_id']}&fields=formatted_phone_number&key=$apiKey';

      final detailsResponse = await http.get(Uri.parse(detailsUrl));
      final detailsData = json.decode(detailsResponse.body);

      resto['phone'] = detailsData['result']?['formatted_phone_number'] ??
          'Teléfono no disponible';

      resto['distance'] = Geolocator.distanceBetween(
        lat,
        lng,
        resto['lat'],
        resto['lng'],
      );
    }

    fetched.sort((a, b) {
      final ratingA = double.tryParse(a['rating'] ?? '0') ?? 0;
      final ratingB = double.tryParse(b['rating'] ?? '0') ?? 0;
      return ratingB.compareTo(ratingA);
    });

    setState(() {
      restaurants = fetched;
      isLoading = false;
      gpsFailed = false;
    });
  }

  Future<void> _fetchByComuna() async {
    final comuna = comunaController.text.trim();
    if (comuna.isEmpty) return;

    setState(() => isLoading = true);

    final geoUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$comuna,Santiago,Chile&key=$apiKey';
    final response = await http.get(Uri.parse(geoUrl));
    final data = json.decode(response.body);

    if (data['results'] != null && data['results'].isNotEmpty) {
      final location = data['results'][0]['geometry']['location'];
      await _loadNearbyPlaces(location['lat'], location['lng']);
    } else {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró esa comuna')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurantes Cercanos 🍽️'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : gpsFailed
              ? _buildComunaInput()
              : _buildRestaurantList(),
    );
  }

  Widget _buildComunaInput() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No se pudo obtener tu ubicación 📍\nIngresa tu comuna de Santiago:',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: comunaController,
            decoration: const InputDecoration(
              labelText: 'Ejemplo: Peñalolén, Chicureo, Providencia...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _fetchByComuna,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('Buscar Restaurantes'),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantList() {
    return restaurants.isEmpty
        ? const Center(child: Text('No se encontraron restaurantes.'))
        : ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final r = restaurants[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading:
                      const Icon(Icons.restaurant, color: Colors.teal, size: 28),
                  title: Text(
                    r['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('⭐ Calificación: ${r['rating']}'),
                      Text('📞 ${r['phone']}'),
                      Text(
                          '📍 ${(r['distance'] / 1000).toStringAsFixed(2)} km'),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
