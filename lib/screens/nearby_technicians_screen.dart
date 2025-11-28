import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// 🎨 Colores de la app (ajusta si quieres)
const kPrimaryColor = Color(0xFF1B4965);      // teal oscuro
const kSecondaryColor = Color(0xFF5FA8D3);    // teal clarito
const kBackgroundColor = Color(0xFFF4F6FA);   // fondo suave

class NearbyTechniciansScreen extends StatefulWidget {
  const NearbyTechniciansScreen({Key? key}) : super(key: key);

  @override
  State<NearbyTechniciansScreen> createState() =>
      _NearbyTechniciansScreenState();
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

  final String apiKey =
      "AIzaSyB0nC__AJm9rMkS3huOeaXeMgx4tA2KgcQ"; // tu API key

  @override
  void initState() {
    super.initState();
    fetchNearbyTechnicians();
    _searchController.addListener(_filterTechnicians);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

      // Eliminar duplicados por place_id
      final uniqueResults = {
        for (var e in allResults) e['place_id']: e,
      }.values.toList();

      // 🔹 Obtener teléfonos de cada técnico (Place Details)
      for (var tech in uniqueResults) {
        final placeId = tech['place_id'];
        if (placeId == null) continue;

        final detailsUrl =
            "https://maps.googleapis.com/maps/api/place/details/json"
            "?place_id=$placeId&fields=formatted_phone_number&key=$apiKey";

        final detailsResponse = await http.get(Uri.parse(detailsUrl));
        if (detailsResponse.statusCode == 200) {
          final detailsData = json.decode(detailsResponse.body);
          final phone =
              detailsData['result']?['formatted_phone_number'] as String?;
          tech['phone'] = phone; // puede ser null
        }
      }

      // 🔹 Ordenar de mejor a peor rating
      uniqueResults.sort((a, b) {
        final ra = (a['rating'] is num) ? (a['rating'] as num).toDouble() : 0.0;
        final rb = (b['rating'] is num) ? (b['rating'] as num).toDouble() : 0.0;
        return rb.compareTo(ra); // desc
      });

      setState(() {
        technicians = uniqueResults;
        filteredTechnicians = uniqueResults;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      debugPrint("Error obteniendo técnicos: $e");
    }
  }

  void _filterTechnicians() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredTechnicians = technicians.where((tech) {
        final name = (tech['name'] ?? '').toLowerCase();
        final vicinity = (tech['vicinity'] ?? '').toLowerCase();
        final types = (tech['types']?.join(' ') ?? '').toLowerCase();
        return name.contains(query) ||
            vicinity.contains(query) ||
            types.contains(query);
      }).toList();
    });
  }

  void _selectSuggestion(String text) {
    _searchController.text = text;
    _filterTechnicians();
  }

  Future<void> _callPhone(String phone) async {
    final clean = phone.replaceAll(' ', '');
    final uri = Uri(scheme: 'tel', path: clean);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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
          "Técnicos cercanos 🔧",
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
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
                          prefixIcon: const Icon(Icons.search,
                              color: kPrimaryColor),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                const BorderSide(color: kPrimaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.grey),
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
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final suggestion = suggestions[index];
                            return GestureDetector(
                              onTap: () => _selectSuggestion(suggestion),
                              child: Chip(
                                label: Text(
                                  suggestion,
                                  style:
                                      const TextStyle(color: kPrimaryColor),
                                ),
                                backgroundColor: kSecondaryColor,
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
                            final name = tech['name'] ?? "Sin nombre";
                            final address =
                                tech['vicinity'] ?? "Dirección no disponible";
                            final rating = tech['rating'];
                            final ratingText =
                                rating != null ? rating.toString() : '-';
                            final phone = tech['phone'] as String?;
                            final hasPhone =
                                phone != null && phone.trim().isNotEmpty;

                            return Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 3,
                              margin:
                                  const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: const Icon(Icons.handyman,
                                    color: kPrimaryColor),
                                title: Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(address),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            size: 18, color: Colors.amber),
                                        const SizedBox(width: 2),
                                        Text(
                                          ratingText,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // ☎ Teléfono en vez de la estrella
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.phone,
                                    color: hasPhone
                                        ? kPrimaryColor
                                        : Colors.grey,
                                  ),
                                  tooltip: hasPhone
                                      ? 'Llamar técnico'
                                      : 'Teléfono no disponible',
                                  onPressed: hasPhone
                                      ? () => _callPhone(phone)
                                      : null,
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
