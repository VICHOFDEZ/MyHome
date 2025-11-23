import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class NearbyTechniciansScreen extends StatefulWidget {
  const NearbyTechniciansScreen({Key? key}) : super(key: key);

  @override
  State<NearbyTechniciansScreen> createState() => _NearbyTechniciansScreenState();
}

class _NearbyTechniciansScreenState extends State<NearbyTechniciansScreen> {
  List<dynamic> technicians = [];
  List<dynamic> filteredTechnicians = [];
  bool loading = true;
  final TextEditingController _searchController = TextEditingController();

  final List<String> suggestions = [
    "Electricista",
    "Gasfiter",
    "Cerrajero",
    "Plomero",
    "Refrigeración",
    "Reparaciones"
  ];

  final String apiKey = "AIzaSyB0nC__AJm9rMkS3huOeaXeMgx4tA2KgcQ"; // tu API key

  @override
  void initState() {
    super.initState();
    fetchNearbyTechnicians();
    _searchController.addListener(_filterTechnicians);
  }

  Future<void> fetchNearbyTechnicians() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final double lat = position.latitude;
      final double lng = position.longitude;

      List<String> keywords = [
        "electricista",
        "gasfitería",
        "cerrajero",
        "reparaciones",
        "electrodomésticos",
        "plomero"
      ];

      List<dynamic> allResults = [];

      for (String keyword in keywords) {
        final url =
            "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=4000&keyword=$keyword&key=$apiKey";

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['results'] != null) {
            allResults.addAll(data['results']);
          }
        }
      }

      // Eliminar duplicados por nombre
      final uniqueResults = {
        for (var e in allResults) e['name']: e,
      }.values.toList();

      setState(() {
        technicians = uniqueResults;
        filteredTechnicians = uniqueResults;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print("Error obteniendo técnicos: $e");
    }
  }

  void _filterTechnicians() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredTechnicians = technicians.where((tech) {
        final name = (tech['name'] ?? '').toLowerCase();
        final vicinity = (tech['vicinity'] ?? '').toLowerCase();
        final types = (tech['types']?.join(' ') ?? '').toLowerCase();
        return name.contains(query) || vicinity.contains(query) || types.contains(query);
      }).toList();
    });
  }

  void _selectSuggestion(String text) {
    _searchController.text = text;
    _filterTechnicians();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Técnicos cercanos 🔧"),
        backgroundColor: Colors.teal,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : technicians.isEmpty
              ? const Center(child: Text("No se encontraron técnicos cerca."))
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // 🔍 Campo de búsqueda
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar técnico o comuna...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 💡 Sugerencias rápidas
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: suggestions.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final suggestion = suggestions[index];
                            return GestureDetector(
                              onTap: () => _selectSuggestion(suggestion),
                              child: Chip(
                                label: Text(suggestion),
                                backgroundColor: Colors.teal.shade100,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 📋 Lista de técnicos
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredTechnicians.length,
                          itemBuilder: (context, index) {
                            final tech = filteredTechnicians[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: const Icon(Icons.handyman, color: Colors.teal),
                                title: Text(
                                  tech['name'] ?? "Sin nombre",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  tech['vicinity'] ?? "Dirección no disponible",
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber),
                                    Text("${tech['rating'] ?? '-'}"),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
