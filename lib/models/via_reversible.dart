// lib/models/via_reversible.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViaReversible {
  final String nombre;
  final String comuna;
  final String tramo;
  final TimeOfDay amInicio;
  final TimeOfDay amFin;
  final String amSentido;
  final TimeOfDay pmInicio;
  final TimeOfDay pmFin;
  final String pmSentido;
  final List<LatLng> puntosMapa;

  const ViaReversible({
    required this.nombre,
    required this.comuna,
    required this.tramo,
    required this.amInicio,
    required this.amFin,
    required this.amSentido,
    required this.pmInicio,
    required this.pmFin,
    required this.pmSentido,
    required this.puntosMapa,
  });
}

/// IMPORTANTE:
/// - Si una vía NO tiene horario PM, dejo pmInicio/pmFin en 00:00 y pmSentido = 'Sin reversibilidad en la tarde'.
/// - Lo mismo al revés si solo tiene tarde.
/// - Los LatLng son aproximados para que se vea el tramo; después puedes afinarlos.
const List<ViaReversible> viasReversibles = [
  // 1) Av. Vicuña Mackenna
  ViaReversible(
    nombre: 'Av. Vicuña Mackenna',
    comuna: 'Santiago / Ñuñoa / Macul',
    tramo: 'Av. Matta – Av. Departamental',
    amInicio: TimeOfDay(hour: 7, minute: 0),
    amFin: TimeOfDay(hour: 9, minute: 0),
    amSentido: 'Hacia el norte (entra al centro en la mañana)',
    pmInicio: TimeOfDay(hour: 17, minute: 0),
    pmFin: TimeOfDay(hour: 20, minute: 0),
    pmSentido: 'Hacia el sur (sale del centro en la tarde)',
    puntosMapa: [
      LatLng(-33.4678, -70.6355),
      LatLng(-33.4760, -70.6278),
      LatLng(-33.4850, -70.6265),
      LatLng(-33.4945, -70.6255),
    ],
  ),

  // 2) Av. Grecia
  ViaReversible(
    nombre: 'Av. Grecia',
    comuna: 'Ñuñoa / Peñalolén',
    tramo: 'Av. Tobalaba – Av. Américo Vespucio',
    amInicio: TimeOfDay(hour: 7, minute: 0),
    amFin: TimeOfDay(hour: 10, minute: 0),
    amSentido: 'Hacia el oriente (mañana, va a Peñalolén)',
    pmInicio: TimeOfDay(hour: 17, minute: 0),
    pmFin: TimeOfDay(hour: 20, minute: 0),
    pmSentido: 'Hacia el poniente (tarde, vuelve hacia Ñuñoa)',
    puntosMapa: [
      LatLng(-33.4570, -70.5835),
      LatLng(-33.4575, -70.5710),
      LatLng(-33.4580, -70.5570),
    ],
  ),

  // 3) Av. Tobalaba
  ViaReversible(
    nombre: 'Av. Tobalaba',
    comuna: 'Providencia / Ñuñoa / La Reina / Peñalolén',
    tramo: 'Av. Grecia – Av. Américo Vespucio Sur',
    amInicio: TimeOfDay(hour: 7, minute: 0),
    amFin: TimeOfDay(hour: 9, minute: 30),
    amSentido: 'Hacia el sur en la mañana',
    pmInicio: TimeOfDay(hour: 17, minute: 0),
    pmFin: TimeOfDay(hour: 20, minute: 0),
    pmSentido: 'Hacia el norte en la tarde',
    puntosMapa: [
      LatLng(-33.4305, -70.5795),
      LatLng(-33.4405, -70.5760),
      LatLng(-33.4525, -70.5690),
      LatLng(-33.4725, -70.5575),
    ],
  ),

  // 4) Av. Oriental
  ViaReversible(
    nombre: 'Av. Oriental',
    comuna: 'Ñuñoa / La Reina',
    tramo: 'Tobalaba – Américo Vespucio (AM) / Los Molineros – Plaza Egaña (PM)',
    amInicio: TimeOfDay(hour: 7, minute: 0),
    amFin: TimeOfDay(hour: 9, minute: 30),
    amSentido: 'Hacia el poniente en la mañana',
    pmInicio: TimeOfDay(hour: 17, minute: 0),
    pmFin: TimeOfDay(hour: 21, minute: 0),
    pmSentido: 'Hacia el poniente en la tarde (otro tramo)',
    puntosMapa: [
      LatLng(-33.4480, -70.5670),
      LatLng(-33.4520, -70.5630),
      LatLng(-33.4560, -70.5590),
    ],
  ),

  // 5) Eje Larraín – Irarrázaval – 10 de Julio
  ViaReversible(
    nombre: 'Eje Larraín – Irarrázaval – 10 de Julio',
    comuna: 'La Reina / Ñuñoa / Santiago',
    tramo: 'Av. Tobalaba – Av. Portugal',
    amInicio: TimeOfDay(hour: 7, minute: 30),
    amFin: TimeOfDay(hour: 10, minute: 0),
    amSentido: 'Hacia el poniente (entra a Santiago Centro)',
    pmInicio: TimeOfDay(hour: 0, minute: 0),
    pmFin: TimeOfDay(hour: 0, minute: 0),
    pmSentido: 'Sin reversibilidad en la tarde',
    puntosMapa: [
      LatLng(-33.4440, -70.5540), // Larraín
      LatLng(-33.4500, -70.5810), // Irarrázaval
      LatLng(-33.4570, -70.6300), // 10 de Julio
    ],
  ),

  // 6) Av. Cristóbal Colón
  ViaReversible(
    nombre: 'Av. Cristóbal Colón',
    comuna: 'Las Condes / La Reina',
    tramo: 'Pontevedra – Av. Tobalaba',
    amInicio: TimeOfDay(hour: 7, minute: 0),
    amFin: TimeOfDay(hour: 10, minute: 0),
    amSentido: 'Principalmente hacia el poniente en la mañana',
    pmInicio: TimeOfDay(hour: 0, minute: 0),
    pmFin: TimeOfDay(hour: 0, minute: 0),
    pmSentido: 'Sin reversibilidad en la tarde',
    puntosMapa: [
      LatLng(-33.4160, -70.5440),
      LatLng(-33.4260, -70.5520),
      LatLng(-33.4350, -70.5600),
    ],
  ),

  // 7) Presidente Riesco
  ViaReversible(
    nombre: 'Av. Presidente Riesco',
    comuna: 'Las Condes',
    tramo: 'Las Tranqueras – Costanera Andrés Bello',
    amInicio: TimeOfDay(hour: 7, minute: 30),
    amFin: TimeOfDay(hour: 12, minute: 0),
    amSentido: 'Hacia el poniente en la mañana',
    pmInicio: TimeOfDay(hour: 12, minute: 0),
    pmFin: TimeOfDay(hour: 21, minute: 0),
    pmSentido: 'Hacia el oriente en la tarde',
    puntosMapa: [
      LatLng(-33.4105, -70.5675),
      LatLng(-33.4085, -70.5780),
      LatLng(-33.4070, -70.5855),
    ],
  ),

  // 8) José Pedro Alessandri – Chile España – Artigas
  ViaReversible(
    nombre: 'José Pedro Alessandri – Chile España – Artigas',
    comuna: 'Macul / Ñuñoa',
    tramo: 'Las Encinas – Av. Sucre',
    amInicio: TimeOfDay(hour: 7, minute: 30),
    amFin: TimeOfDay(hour: 10, minute: 0),
    amSentido: 'Hacia el norte en la mañana',
    pmInicio: TimeOfDay(hour: 0, minute: 0),
    pmFin: TimeOfDay(hour: 0, minute: 0),
    pmSentido: 'Sin reversibilidad en la tarde',
    puntosMapa: [
      LatLng(-33.4870, -70.6030),
      LatLng(-33.4730, -70.6030),
      LatLng(-33.4605, -70.6025),
    ],
  ),

  // 9) Carlos Ossandón
  ViaReversible(
    nombre: 'Carlos Ossandón',
    comuna: 'La Reina / Ñuñoa',
    tramo: 'Av. Larraín – Valenzuela Puelma',
    amInicio: TimeOfDay(hour: 7, minute: 0),
    amFin: TimeOfDay(hour: 9, minute: 0),
    amSentido: 'Hacia el norte en la mañana',
    pmInicio: TimeOfDay(hour: 17, minute: 0),
    pmFin: TimeOfDay(hour: 21, minute: 0),
    pmSentido: 'Hacia el sur en la tarde',
    puntosMapa: [
      LatLng(-33.4380, -70.5480),
      LatLng(-33.4470, -70.5480),
    ],
  ),

  // 10) Gerónimo de Alderete – Bacteriológico – Av. Perú (eje norte-sur)
  ViaReversible(
    nombre: 'Eje Bacteriológico – Av. Perú',
    comuna: 'La Florida / Puente Alto',
    tramo: 'Av. Trinidad – Gerónimo de Alderete / Gerónimo de Alderete – Enrique Olivares',
    amInicio: TimeOfDay(hour: 7, minute: 0),
    amFin: TimeOfDay(hour: 10, minute: 0),
    amSentido: 'Hacia el norte en la mañana',
    pmInicio: TimeOfDay(hour: 17, minute: 0),
    pmFin: TimeOfDay(hour: 21, minute: 0),
    pmSentido: 'Hacia el sur en la tarde (tramo Av. Perú)',
    puntosMapa: [
      LatLng(-33.5520, -70.5755),
      LatLng(-33.5400, -70.5740),
      LatLng(-33.5280, -70.5725),
    ],
  ),

  // 11) Manutara
  ViaReversible(
    nombre: 'Manutara',
    comuna: 'La Florida',
    tramo: 'Av. San José de la Estrella – Gerónimo de Alderete',
    amInicio: TimeOfDay(hour: 7, minute: 0),
    amFin: TimeOfDay(hour: 10, minute: 0),
    amSentido: 'Hacia el norte en la mañana',
    pmInicio: TimeOfDay(hour: 17, minute: 0),
    pmFin: TimeOfDay(hour: 21, minute: 0),
    pmSentido: 'Hacia el sur en la tarde',
    puntosMapa: [
      LatLng(-33.5580, -70.5670),
      LatLng(-33.5480, -70.5670),
      LatLng(-33.5380, -70.5665),
    ],
  ),

  // 12) Las Acacias
  ViaReversible(
    nombre: 'Las Acacias',
    comuna: 'La Florida',
    tramo: 'Gerónimo de Alderete – Américo Vespucio',
    amInicio: TimeOfDay(hour: 7, minute: 0),
    amFin: TimeOfDay(hour: 10, minute: 0),
    amSentido: 'Hacia el norte en la mañana',
    pmInicio: TimeOfDay(hour: 17, minute: 0),
    pmFin: TimeOfDay(hour: 21, minute: 0),
    pmSentido: 'Hacia el sur en la tarde',
    puntosMapa: [
      LatLng(-33.5400, -70.5620),
      LatLng(-33.5300, -70.5590),
    ],
  ),

  // 13) Consistorial
  ViaReversible(
    nombre: 'Consistorial',
    comuna: 'Peñalolén',
    tramo: 'Av. Grecia – Av. José Arrieta',
    amInicio: TimeOfDay(hour: 7, minute: 0),
    amFin: TimeOfDay(hour: 9, minute: 30),
    amSentido: 'Hacia el norte en la mañana',
    pmInicio: TimeOfDay(hour: 0, minute: 0),
    pmFin: TimeOfDay(hour: 0, minute: 0),
    pmSentido: 'Sin reversibilidad en la tarde',
    puntosMapa: [
      LatLng(-33.4825, -70.5635),
      LatLng(-33.4735, -70.5635),
    ],
  ),

  // 14) Salvador
  ViaReversible(
    nombre: 'Av. Salvador',
    comuna: 'Ñuñoa / Providencia',
    tramo: 'Av. Grecia – Av. Providencia',
    amInicio: TimeOfDay(hour: 7, minute: 30),
    amFin: TimeOfDay(hour: 10, minute: 0),
    amSentido: 'Hacia el norte en la mañana',
    pmInicio: TimeOfDay(hour: 17, minute: 0),
    pmFin: TimeOfDay(hour: 21, minute: 0),
    pmSentido: 'Hacia el sur en la tarde',
    puntosMapa: [
      LatLng(-33.4715, -70.6185),
      LatLng(-33.4525, -70.6185),
      LatLng(-33.4375, -70.6185),
    ],
  ),

  // 15) San Ignacio
  ViaReversible(
    nombre: 'San Ignacio',
    comuna: 'San Joaquín / San Miguel',
    tramo: 'Av. La Marina – Av. Diez de Julio (AM) / La Marina – Carlos Valdovinos (PM)',
    amInicio: TimeOfDay(hour: 7, minute: 30),
    amFin: TimeOfDay(hour: 10, minute: 0),
    amSentido: 'Hacia el norte en la mañana',
    pmInicio: TimeOfDay(hour: 17, minute: 0),
    pmFin: TimeOfDay(hour: 21, minute: 0),
    pmSentido: 'Hacia el sur en la tarde',
    puntosMapa: [
      LatLng(-33.4930, -70.6460),
      LatLng(-33.4820, -70.6460),
      LatLng(-33.4720, -70.6460),
    ],
  ),

  // 16) 3er Transversal – Gauss – Guido Riquelme
  ViaReversible(
    nombre: '3er Transversal – Gauss – Guido Riquelme',
    comuna: 'La Cisterna / San Ramón',
    tramo: 'Av. Lo Ovalle – Av. El Parrón',
    amInicio: TimeOfDay(hour: 7, minute: 30),
    amFin: TimeOfDay(hour: 10, minute: 0),
    amSentido: 'Hacia el norte en la mañana',
    pmInicio: TimeOfDay(hour: 17, minute: 0),
    pmFin: TimeOfDay(hour: 21, minute: 0),
    pmSentido: 'Hacia el sur en la tarde',
    puntosMapa: [
      LatLng(-33.5210, -70.6570),
      LatLng(-33.5105, -70.6570),
    ],
  ),

  // 17) Mapocho
  ViaReversible(
    nombre: 'Mapocho',
    comuna: 'Quinta Normal',
    tramo: 'Alcerreca – Av. Matucana',
    amInicio: TimeOfDay(hour: 7, minute: 30),
    amFin: TimeOfDay(hour: 10, minute: 0),
    amSentido: 'Hacia el oriente en la mañana',
    pmInicio: TimeOfDay(hour: 0, minute: 0),
    pmFin: TimeOfDay(hour: 0, minute: 0),
    pmSentido: 'Sin reversibilidad en la tarde',
    puntosMapa: [
      LatLng(-33.4320, -70.7030),
      LatLng(-33.4320, -70.6920),
    ],
  ),

  // 18) Nueva Imperial – Portales
  ViaReversible(
    nombre: 'Nueva Imperial – Av. Portales',
    comuna: 'Estación Central / Quinta Normal',
    tramo: 'Av. Las Rejas – Av. Matucana',
    amInicio: TimeOfDay(hour: 7, minute: 30),
    amFin: TimeOfDay(hour: 10, minute: 0),
    amSentido: 'Hacia el oriente en la mañana',
    pmInicio: TimeOfDay(hour: 0, minute: 0),
    pmFin: TimeOfDay(hour: 0, minute: 0),
    pmSentido: 'Sin reversibilidad en la tarde',
    puntosMapa: [
      LatLng(-33.4480, -70.7120),
      LatLng(-33.4480, -70.6980),
    ],
  ),
];
