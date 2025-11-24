import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  // 👇 Cambia este correo por el tuyo
  static const String _adminEmail = 'myhomeadmin@gmail.com';

  // ---------- DATOS DE EJEMPLO ----------

  List<_TutorCareer> get _careers => [
        _TutorCareer(
          name: 'Ingeniería Civil',
          description: 'Ramos de Plan común.',
          classes: [
            _TutorClass(
              name: 'Programación',
              tutors: [
                _Tutor(
                  name: 'Ignacio Pérez',
                  phone: '+56944444444',
                  pricePerHour: 13000,
                  description: 'Simulaciones, tracker y ejercicios de pruebas antiguas.',
                  modality: 'Online',
                ),
              ],
            ),
            _TutorClass(
              name: 'Cálculo / Cálculo Integral',
              tutors: [
                _Tutor(
                  name: 'Francisca Martínez',
                  phone: '+56911111111',
                  pricePerHour: 12000,
                  description: 'Estudiante de 4to año, experiencia haciendo ayudantías y preu.',
                  modality: 'Online y presencial',
                ),
                _Tutor(
                  name: 'Tomás Rojas',
                  phone: '+56922222222',
                  pricePerHour: 10000,
                  description: 'Explicaciones con muchos ejercicios tipo control.',
                  modality: 'Solo online',
                ),
              ],
            ),
            _TutorClass(
              name: 'Cálculo Multivariables',
              tutors: [
                _Tutor(
                  name: 'Camila Herrera',
                  phone: '+56933333333',
                  pricePerHour: 11000,
                  description: 'Foco en resolución de guías y preparación de exámenes.',
                  modality: 'Presencial en UAI / Metro',
                ),
              ],
            ),
            _TutorClass(
              name: 'Ecuaciones Diferenciales',
              tutors: [
                _Tutor(
                  name: 'Ignacio Pérez',
                  phone: '+56944444444',
                  pricePerHour: 13000,
                  description: 'Simulaciones, tracker y ejercicios de pruebas antiguas.',
                  modality: 'Online',
                ),
              ],
            ),
            _TutorClass(
              name: 'Álgebra / Álgebra Lineal',
              tutors: [
                _Tutor(
                  name: 'Ignacio Pérez',
                  phone: '+56944444444',
                  pricePerHour: 13000,
                  description: 'Simulaciones, tracker y ejercicios de pruebas antiguas.',
                  modality: 'Online',
                ),
              ],
            ),
             _TutorClass(
              name: 'Probabilidad y Estadística',
              tutors: [
                _Tutor(
                  name: 'Ignacio Pérez',
                  phone: '+56944444444',
                  pricePerHour: 13000,
                  description: 'Simulaciones, tracker y ejercicios de pruebas antiguas.',
                  modality: 'Online',
                ),
              ],
            ),
            _TutorClass(
              name: 'Fundamentos de Ciencia de Datos',
              tutors: [
                _Tutor(
                  name: 'Ignacio Pérez',
                  phone: '+56944444444',
                  pricePerHour: 13000,
                  description: 'Simulaciones, tracker y ejercicios de pruebas antiguas.',
                  modality: 'Online',
                ),
              ],
            ),
            _TutorClass(
              name: 'Física II',
              tutors: [
                _Tutor(
                  name: 'Ignacio Pérez',
                  phone: '+56944444444',
                  pricePerHour: 13000,
                  description: 'Simulaciones, tracker y ejercicios de pruebas antiguas.',
                  modality: 'Online',
                ),
              ],
            ),
            _TutorClass(
              name: 'Física III',
              tutors: [
                _Tutor(
                  name: 'Ignacio Pérez',
                  phone: '+56944444444',
                  pricePerHour: 13000,
                  description: 'Simulaciones, tracker y ejercicios de pruebas antiguas.',
                  modality: 'Online',
                ),
              ],
            ),
          ],
        ),
        _TutorCareer(
          name: 'Ingeniería Comercial',
          description: 'Apoyo en ramos cuantitativos y de gestión.',
          classes: [
            _TutorClass(
              name: 'Matemáticas Avanzadas I',
              tutors: [
                _Tutor(
                  name: 'Valentina Soto',
                  phone: '+56955555555',
                  pricePerHour: 9000,
                  description: 'Clases con ejemplos de la realidad chilena, muchas gráficas.',
                  modality: 'Online y presencial',
                ),
              ],
            ),
            _TutorClass(
              name: 'Matemáticas Avanzadas II',
              tutors: [
                _Tutor(
                  name: 'Diego González',
                  phone: '+56966666666',
                  pricePerHour: 11000,
                  description: 'Uso de Excel/R, preparación para controles y proyectos.',
                  modality: 'Online',
                ),
              ],
            ),
            _TutorClass(
              name: 'Razonamiento Cuantitativo con Datos I',
              tutors: [
                _Tutor(
                  name: 'Diego González',
                  phone: '+56966666666',
                  pricePerHour: 11000,
                  description: 'Uso de Excel/R, preparación para controles y proyectos.',
                  modality: 'Online',
                ),
              ],
            ),
            _TutorClass(
              name: 'Razonamiento Cuantitativo con Datos II',
              tutors: [
                _Tutor(
                  name: 'Diego González',
                  phone: '+56966666666',
                  pricePerHour: 11000,
                  description: 'Uso de Excel/R, preparación para controles y proyectos.',
                  modality: 'Online',
                ),
              ],
            ),
            _TutorClass(
              name: 'Introducción a la Microeconomía',
              tutors: [
                _Tutor(
                  name: 'Diego González',
                  phone: '+56966666666',
                  pricePerHour: 11000,
                  description: 'Uso de Excel/R, preparación para controles y proyectos.',
                  modality: 'Online',
                ),
              ],
            ),
            _TutorClass(
              name: 'Introducción a la Macroeconomía',
              tutors: [
                _Tutor(
                  name: 'Diego González',
                  phone: '+56966666666',
                  pricePerHour: 11000,
                  description: 'Uso de Excel/R, preparación para controles y proyectos.',
                  modality: 'Online',
                ),
              ],
            ),
            _TutorClass(
              name: 'Management',
              tutors: [
                _Tutor(
                  name: 'Diego González',
                  phone: '+56966666666',
                  pricePerHour: 11000,
                  description: 'Uso de Excel/R, preparación para controles y proyectos.',
                  modality: 'Online',
                ),
              ],
            ),
          ],
        ),
        _TutorCareer(
          name: 'Derecho',
          description: 'Ayuda en ramos teóricos y prácticos.',
          classes: [
            _TutorClass(
              name: 'Historia del Derecho',
              tutors: [
                _Tutor(
                  name: 'Sofía Fuentes',
                  phone: '+56977777777',
                  pricePerHour: 9500,
                  description: 'Te ayuda a entender estadísticas aplicadas a psicología.',
                  modality: 'Online',
                ),
              ],
            ),
            _TutorClass(
              name: 'Destrezas Forenses',
              tutors: [
                _Tutor(
                  name: 'Felipe Navarro',
                  phone: '+56988888888',
                  pricePerHour: 10000,
                  description: 'Resumenes, mapas conceptuales y preparación de orales.',
                  modality: 'Presencial región Metropolitana',
                ),
              ],
            ),
          ],
        ),
        _TutorCareer(
          name: 'Psicología',
          description: 'Clases para apoyo en pasajes complejos.',
          classes: [
            _TutorClass(
              name: 'Bases Teóricas de la Psicología',
              tutors: [
                _Tutor(
                  name: 'Sofía Fuentes',
                  phone: '+56977777777',
                  pricePerHour: 9500,
                  description: 'Te ayuda a entender estadísticas aplicadas a psicología.',
                  modality: 'Online',
                ),
              ],
            ),
            _TutorClass(
              name: 'Psicología del Aprendizaje',
              tutors: [
                _Tutor(
                  name: 'Felipe Navarro',
                  phone: '+56988888888',
                  pricePerHour: 10000,
                  description: 'Resumenes, mapas conceptuales y preparación de orales.',
                  modality: 'Presencial región Metropolitana',
                ),
              ],
            ),
          ],
        ),
        _TutorCareer(
          name: 'Otras carreras',
          description: 'Espacio para carreras como International Managment, Periodismo, etc.',
          classes: [
            _TutorClass(
              name: 'International Management',
              tutors: [
                _Tutor(
                  name: 'Sofía Fuentes',
                  phone: '+56977777777',
                  pricePerHour: 9500,
                  description: 'Te ayuda a entender estadísticas aplicadas a psicología.',
                  modality: 'Online',
                ),
              ],
            ),
            _TutorClass(
              name: 'Periodismo',
              tutors: [
                _Tutor(
                  name: 'Felipe Navarro',
                  phone: '+56988888888',
                  pricePerHour: 10000,
                  description: 'Resumenes, mapas conceptuales y preparación de orales.',
                  modality: 'Presencial región Metropolitana',
                ),
              ],
            ),
          ],
        ),
      ];

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutores'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Busca tutores según tu carrera y ramo. '
            'Contacta directamente por WhatsApp o llamada.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          ..._careers.map(_buildCareerTile),
          const SizedBox(height: 24),
          _buildBeTutorCard(context),
        ],
      ),
    );
  }

  Widget _buildCareerTile(_TutorCareer career) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          career.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          career.description,
          style: const TextStyle(fontSize: 13),
        ),
        children: career.classes.map(_buildClassTile).toList(),
      ),
    );
  }

  Widget _buildClassTile(_TutorClass tutorClass) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Card(
        elevation: 0,
        color: Colors.grey[50],
        child: ExpansionTile(
          title: Text(
            tutorClass.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          children: tutorClass.tutors.map(_buildTutorTile).toList(),
        ),
      ),
    );
  }

  Widget _buildTutorTile(_Tutor tutor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        child: ListTile(
          title: Text(
            tutor.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                tutor.description,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 6),
              Text(
                'Modalidad: ${tutor.modality}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'Valor aproximado: \$${tutor.pricePerHour.toStringAsFixed(0)} / hora',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                'Teléfono: ${tutor.phone}',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () => _callPhone(tutor.phone),
          ),
        ),
      ),
    );
  }

  Widget _buildBeTutorCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Quieres ser tutor?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Si quieres aparecer en esta lista como profesor particular, '
              'envíanos un correo con:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 6),
            const Text(
              '• Nombre completo\n'
              '• Descripcion en 1 linea\n'
              '• Carrera y universidad\n'
              '• Ramos que puedes hacer clases\n'
              '• Modalidad (online/presencial)\n'
              '• Valor por hora\n'
              '• Número de teléfono para contacto',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _sendTutorEmail(context),
                icon: const Icon(Icons.email),
                label: const Text('Postular como tutor'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- ACCIONES ----------

  static Future<void> _callPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static Future<void> _sendTutorEmail(BuildContext context) async {
    final subject = 'Postulación como tutor - MyHome';
    final body = '''
Hola,

Quiero postular para ser tutor en la app MyHome.

Nombre y Apellido:
Descripción breve:
Carrera y universidad:
Ramos que puedo hacer clases:
Modalidad (online/presencial):
Valor por hora:
Número de teléfono:

Saludos,
''';

    final uri = Uri(
      scheme: 'mailto',
      path: _adminEmail,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir la app de correo.'),
        ),
      );
    }
  }
}

// ---------- MODELOS SIMPLES ----------

class _TutorCareer {
  final String name;
  final String description;
  final List<_TutorClass> classes;

  const _TutorCareer({
    required this.name,
    required this.description,
    required this.classes,
  });
}

class _TutorClass {
  final String name;
  final List<_Tutor> tutors;

  const _TutorClass({
    required this.name,
    required this.tutors,
  });
}

class _Tutor {
  final String name;
  final String phone;
  final double pricePerHour;
  final String description;
  final String modality;

  const _Tutor({
    required this.name,
    required this.phone,
    required this.pricePerHour,
    required this.description,
    required this.modality,
  });
}
