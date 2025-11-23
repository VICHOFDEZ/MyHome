// lib/models/emergency_profile.dart
class EmergencyProfile {
  final String nombre;
  final String apellido;
  final String tipoSangre;
  final String alergias;
  final String contactoNombre;
  final String contactoTelefono;

  const EmergencyProfile({
    required this.nombre,
    required this.apellido,
    required this.tipoSangre,
    required this.alergias,
    required this.contactoNombre,
    required this.contactoTelefono,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'tipoSangre': tipoSangre,
      'alergias': alergias,
      'contactoNombre': contactoNombre,
      'contactoTelefono': contactoTelefono,
    };
  }

  factory EmergencyProfile.fromMap(Map<String, dynamic> map) {
    return EmergencyProfile(
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      tipoSangre: map['tipoSangre'] ?? '',
      alergias: map['alergias'] ?? '',
      contactoNombre: map['contactoNombre'] ?? '',
      contactoTelefono: map['contactoTelefono'] ?? '',
    );
  }
}
