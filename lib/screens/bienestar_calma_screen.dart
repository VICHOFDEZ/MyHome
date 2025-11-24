// lib/screens/bienestar_calma_screen.dart
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// 🎨 PALETA VERDE RELAJACIÓN (OPCIÓN D)
const kPrimaryColor = Color(0xFF2E7D32);      // verde profundo
const kSecondaryColor = Color(0xFFA5D6A7);    // verde pastel
const kBackgroundColor = Color(0xFFF1F8E9);   // fondo suave

class BienestarCalmaScreen extends StatefulWidget {
  const BienestarCalmaScreen({super.key});

  @override
  State<BienestarCalmaScreen> createState() => _BienestarCalmaScreenState();
}

class _BienestarCalmaScreenState extends State<BienestarCalmaScreen> {
  bool _cargando = true;

  // Frase del día
  String _fraseDelDia = '';
  static const _fraseKey = 'frase_del_dia';
  static const _fraseFechaKey = 'frase_del_dia_fecha';

  // Lista de frases posibles
  static const List<String> _frases = [
    'Un día a la vez.',
    'Respira, lo estás haciendo bien.',
    'Pequeños pasos también son avance.',
    'No tienes que poder con todo hoy.',
    'Eres más fuerte de lo que crees.',
    'Está bien pedir ayuda.',
    'Está bien descansar.',
    'Tu valor no depende de tus notas.',
    'Lo estás intentando, y eso ya cuenta.',
    'Permítete ser principiante.',
    'Un mal día no define tu vida.',
    'Hoy puedes volver a empezar.',
    'Has sobrevivido a todos tus días difíciles.',
    'Tu esfuerzo sí importa, aunque nadie lo vea.',
    'Puedes aprender algo incluso del error.',
    'Estás haciendo lo mejor que puedes.',
    'Un paso más, solo uno.',
    'Nadie tiene todo resuelto, y eso está bien.',
    'No estás solo en esto.',
    'Tu ritmo también es válido.',
    'Está bien decir que no.',
    'Está bien no estar bien a veces.',
    'No todo tiene que ser perfecto.',
    'Puedes avanzar aunque tengas miedo.',
    'Descansar también es productividad.',
    'Tu salud mental es prioridad.',
    'Ya hiciste mucho por hoy.',
    'Puedes ir más lento si lo necesitas.',
    'Date permiso para equivocarte.',
    'Todo gran cambio empieza pequeño.',
    'Lo que sientes también es importante.',
    'Tu voz merece ser escuchada.',
    'Tus emociones no son un problema.',
    'Lo que piensas de ti sí importa.',
    'Cada día aprendes algo nuevo.',
    'Tú también mereces paciencia.',
    'Tú también mereces ternura.',
    'Compararte te roba paz.',
    'Puedes ser amable contigo hoy.',
    'Hay personas que se alegran de que existas.',
    'Puedes respirar hondo y seguir.',
    'Tu descanso no es una pérdida de tiempo.',
    'Hoy puedes tratarte con más cariño.',
    'Lo estás haciendo mejor de lo que crees.',
    'Siempre puedes pedir una mano.',
    'Mereces sentirte seguro y en calma.',
    'Mereces ocupar espacio en este mundo.',
    'Tu historia aún se está escribiendo.',
    'Pequeñas victorias también son victorias.',
    'Puedes construir algo bueno desde aquí.',
    'Puedes aprender a tu propio ritmo.',
    'Lo que hoy pesa, mañana puede pesar menos.',
    'Tu ansiedad no te define.',
    'Tu tristeza no te define.',
    'Tu valor no baja por estar cansado.',
    'Tu progreso no tiene que ser visible.',
    'Puedes tomarte un momento solo para ti.',
    'Ser sensible no es ser débil.',
    'Ser honesto contigo es un acto de valentía.',
    'Estar agotado no te hace menos capaz.',
    'Puedes cambiar de opinión y está bien.',
    'Puedes empezar de nuevo las veces que necesites.',
    'Lo que hoy duele también puede sanar.',
    'Tu cuerpo merece respeto, incluso cuando no rinde.',
    'Tus límites también son importantes.',
    'No tienes que demostrar nada todo el tiempo.',
    'Lo que haces ya es suficiente por hoy.',
    'Puedes pedir un abrazo cuando lo necesites.',
    'Puedes decir “no puedo con esto solo”.',
    'Puedes buscar ayuda profesional y está bien.',
    'Tu vida vale más que cualquier error.',
    'Hay futuro incluso si hoy no lo ves claro.',
    'Tu cansancio es señal de cuánto has dado.',
    'Puedes bajar la exigencia contigo hoy.',
    'Mereces hablarte con la misma ternura que a un amigo.',
    'Está bien celebrar cosas pequeñas.',
    'Puedes tomar agua, respirar y seguir.',
    'Mereces un lugar donde te sientas en casa.',
    'Hay gente que piensa en ti con cariño.',
    'Lo que haces por ti también cuenta.',
    'Tus pausas no frenan tu crecimiento.',
    'Mereces sentirte orgulloso de tus avances.',
    'No eres una carga por necesitar apoyo.',
    'Tu existencia ya es un aporte.',
    'Puedes equivocarte sin odiarte por eso.',
    'Tu miedo no anula tu valentía.',
    'Cada día que sigues aquí es una prueba de tu fuerza.',
    'Puedes aprender a quererte poco a poco.',
    'Tu voz interna puede volverse más amable.',
    'Puedes respirar, mirar alrededor y agradecer algo mínimo.',
    'Tu proceso es único y válido.',
    'No tienes que tener todas las respuestas.',
    'Puedes soltar lo que ya no te hace bien.',
    'Hay espacio para que seas tú mismo.',
    'Estás creciendo, aunque a veces duela.',
    'Hoy puedes hacer una cosa pequeña por ti.',
    'Si solo lograste levantarte, ya lograste algo.',
    'Puedes ver este día como una nueva oportunidad.',
    'Tu valor no se mide por tu productividad.',
    'Aunque avances poco, sigues avanzando.',
  ];

  // Cosas que me calman
  static const _cosasKey = 'cosas_que_me_calman';
  List<String> _cosasCalma = [];

  // Contacto de confianza
  static const _confianzaNombreKey = 'confianza_nombre';
  static const _confianzaNumeroKey = 'confianza_numero';
  String _confianzaNombre = '';
  String _confianzaNumero = '';

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    await _cargarFraseDelDia();
    await _cargarCosasCalma();
    await _cargarContactoConfianza();
    if (mounted) {
      setState(() {
        _cargando = false;
      });
    }
  }

  // --------- FRASE DEL DÍA ---------

  Future<void> _cargarFraseDelDia() async {
    final prefs = await SharedPreferences.getInstance();
    final hoy = DateTime.now();
    final hoyStr = '${hoy.year}-${hoy.month}-${hoy.day}';

    final fechaGuardada = prefs.getString(_fraseFechaKey);
    final fraseGuardada = prefs.getString(_fraseKey);

    if (fechaGuardada == hoyStr && fraseGuardada != null) {
      _fraseDelDia = fraseGuardada;
    } else {
      final random = Random();
      final frase = _frases[random.nextInt(_frases.length)];
      _fraseDelDia = frase;
      await prefs.setString(_fraseKey, frase);
      await prefs.setString(_fraseFechaKey, hoyStr);
    }
  }

  // --------- COSAS QUE ME CALMAN ---------

  Future<void> _cargarCosasCalma() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_cosasKey);
    if (data == null) {
      _cosasCalma = [];
      return;
    }
    final list = jsonDecode(data);
    _cosasCalma = (list as List).map((e) => e.toString()).toList();
  }

  Future<void> _guardarCosasCalma() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cosasKey, jsonEncode(_cosasCalma));
  }

  Future<void> _agregarCosaCalma() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar algo que te calma'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Ej: Tomar té, caminar, escuchar música…',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    _cosasCalma.add(text);
                  });
                  _guardarCosasCalma();
                }
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _eliminarCosaCalma(int index) async {
    setState(() {
      _cosasCalma.removeAt(index);
    });
    await _guardarCosasCalma();
  }

  // --------- CONTACTO DE CONFIANZA ---------

  Future<void> _cargarContactoConfianza() async {
    final prefs = await SharedPreferences.getInstance();
    _confianzaNombre = prefs.getString(_confianzaNombreKey) ?? '';
    _confianzaNumero = prefs.getString(_confianzaNumeroKey) ?? '';
  }

  Future<void> _editarContactoConfianza() async {
    final nombreController = TextEditingController(text: _confianzaNombre);
    final numeroController = TextEditingController(text: _confianzaNumero);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Contacto de confianza'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: numeroController,
                decoration: const InputDecoration(
                  labelText: 'Número de teléfono',
                  hintText: 'Ej: +56912345678',
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _confianzaNombre = nombreController.text.trim();
        _confianzaNumero = numeroController.text.trim();
      });
      await prefs.setString(_confianzaNombreKey, _confianzaNombre);
      await prefs.setString(_confianzaNumeroKey, _confianzaNumero);
    }
  }

  Future<void> _llamarNumero(String numero) async {
    if (numero.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: numero);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // --------- RESPIRACIÓN / PAUSAS ---------

  Future<void> _mostrarDialogoRespiracion() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _BreathingDialog(
        duration: Duration(seconds: 60),
      ),
    );
  }

  Future<void> _mostrarDialogoPausa(Duration duracion) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PauseTimerDialog(duration: duracion),
    );
  }

  // --------- BUILD ---------

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kPrimaryColor)),
      );
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Bienestar & Calma',
          style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFraseDelDia(),
            const SizedBox(height: 16),
            _buildRespiracion(),
            const SizedBox(height: 16),
            _buildGrounding(),  // ahora solo abre pantalla aparte
            const SizedBox(height: 16),
            _buildPausas(),
            const SizedBox(height: 16),
            _buildCosasCalma(),
            const SizedBox(height: 16),
            _buildContactoConfianza(),
          ],
        ),
      ),
    );
  }

  // --------- WIDGETS DE SECCIÓN ---------

  Widget _buildFraseDelDia() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frase del día',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            const Text(
              'Cambia una vez al día',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Text(
              _fraseDelDia,
              style: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRespiracion() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(Icons.air, color: kPrimaryColor),
        title: const Text(
          'Respira 1 minuto',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text(
          'Un ejercicio guiado de respiración para calmarte.',
        ),
        trailing: const Icon(Icons.play_arrow, color: kPrimaryColor),
        onTap: _mostrarDialogoRespiracion,
      ),
    );
  }

  /// En la pantalla principal, ahora el ejercicio de grounding
  /// solo aparece como una tarjeta que lleva a otra vista más enfocada.
  Widget _buildGrounding() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(Icons.self_improvement, color: kPrimaryColor),
        title: const Text(
          'Ejercicio para bajar la ansiedad',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: const Text(
          'Usa lo que te rodea para volver al presente.',
          style: TextStyle(fontSize: 13),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const GroundingExerciseScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPausas() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tomar una pausa',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Elige unos minutos para detenerte y respirar.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _pauseButton('1 min', const Duration(minutes: 1)),
                _pauseButton('3 min', const Duration(minutes: 3)),
                _pauseButton('5 min', const Duration(minutes: 5)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pauseButton(String label, Duration duration) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      onPressed: () => _mostrarDialogoPausa(duration),
      child: Text(label),
    );
  }

  Widget _buildCosasCalma() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cosas que me calman',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Haz tu propia lista de cosas que te hacen sentir mejor.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 8),
            if (_cosasCalma.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Aún no has agregado nada. Empieza con una idea simple 😊',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              )
            else
              Column(
                children: List.generate(_cosasCalma.length, (index) {
                  final texto = _cosasCalma[index];
                  return Dismissible(
                    key: ValueKey('$texto-$index'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _eliminarCosaCalma(index),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      title: Text(texto),
                    ),
                  );
                }),
              ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _agregarCosaCalma,
                icon: const Icon(Icons.add, color: kPrimaryColor),
                label: const Text(
                  'Agregar',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactoConfianza() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Llamar a alguien de confianza',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (_confianzaNombre.isEmpty || _confianzaNumero.isEmpty) ...[
              const Text(
                'Aún no has guardado a nadie como contacto de confianza.',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _editarContactoConfianza,
                  child: const Text(
                    'Agregar contacto',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              ),
            ] else ...[
              Text(
                'Nombre: $_confianzaNombre',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Teléfono: $_confianzaNumero',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _llamarNumero(_confianzaNumero),
                      icon: const Icon(Icons.phone),
                      label: Text('Llamar a $_confianzaNombre'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _editarContactoConfianza,
                    icon: const Icon(Icons.edit, color: kPrimaryColor),
                    tooltip: 'Editar contacto',
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// --------- DIÁLOGO DE RESPIRACIÓN (LENTO) ---------

class _BreathingDialog extends StatefulWidget {
  final Duration duration;

  const _BreathingDialog({required this.duration});

  @override
  State<_BreathingDialog> createState() => _BreathingDialogState();
}

class _BreathingDialogState extends State<_BreathingDialog> {
  late int _secondsLeft;
  late int _phaseSecondsLeft;
  Timer? _timer;
  bool _inhale = true;

  // Duraciones de cada fase (puedes ajustar)
  static const int _inhaleSeconds = 4;
  static const int _exhaleSeconds = 6;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.duration.inSeconds;
    _inhale = true;
    _phaseSecondsLeft = _inhaleSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _secondsLeft--;

        _phaseSecondsLeft--;
        if (_phaseSecondsLeft <= 0) {
          _inhale = !_inhale;
          _phaseSecondsLeft = _inhale ? _inhaleSeconds : _exhaleSeconds;
        }

        if (_secondsLeft <= 0) {
          _timer?.cancel();
          Navigator.of(context).pop();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mensaje = _inhale ? 'Inhala profundo…' : 'Exhala lentamente…';

    final totalSeconds = widget.duration.inSeconds;
    final progress =
        totalSeconds > 0 ? 1 - (_secondsLeft / totalSeconds) : 0.0;

    return AlertDialog(
      title: const Text('Respiración guiada'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            mensaje,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text('Tiempo restante: $_secondsLeft s'),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            color: kPrimaryColor,
            backgroundColor: kSecondaryColor.withOpacity(0.3),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _timer?.cancel();
            Navigator.pop(context);
          },
          child: const Text(
            'Detener',
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}

// --------- DIÁLOGO DE PAUSA ---------

class _PauseTimerDialog extends StatefulWidget {
  final Duration duration;

  const _PauseTimerDialog({required this.duration});

  @override
  State<_PauseTimerDialog> createState() => _PauseTimerDialogState();
}

class _PauseTimerDialogState extends State<_PauseTimerDialog> {
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.duration.inSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) {
          _timer?.cancel();
          Navigator.of(context).pop();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutos = (_secondsLeft / 60).floor();
    final segundos = _secondsLeft % 60;
    final tiempoStr =
        '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';

    final totalSeconds = widget.duration.inSeconds;
    final progress =
        totalSeconds > 0 ? 1 - (_secondsLeft / totalSeconds) : 0.0;

    return AlertDialog(
      title: const Text('Pausa en curso'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Tómate este momento para descansar.'),
          const SizedBox(height: 16),
          Text(
            tiempoStr,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            color: kPrimaryColor,
            backgroundColor: kSecondaryColor.withOpacity(0.3),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _timer?.cancel();
            Navigator.pop(context);
          },
          child: const Text(
            'Cancelar',
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}

// --------- PANTALLA APARTE: EJERCICIO PARA BAJAR LA ANSIEDAD ---------

class GroundingExerciseScreen extends StatefulWidget {
  const GroundingExerciseScreen({super.key});

  @override
  State<GroundingExerciseScreen> createState() =>
      _GroundingExerciseScreenState();
}

class _GroundingExerciseScreenState extends State<GroundingExerciseScreen> {
  bool _gPaso1 = false;
  bool _gPaso2 = false;
  bool _gPaso3 = false;
  bool _gPaso4 = false;
  bool _gPaso5 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Ejercicio para bajar la ansiedad',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ejercicio para bajar la ansiedad',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Usa lo que te rodea para volver al presente:',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                _groundingItem(
                  'Nombra 5 cosas que puedes ver',
                  _gPaso1,
                  (v) => setState(() => _gPaso1 = v),
                ),
                _groundingItem(
                  'Nombra 4 cosas que puedes tocar',
                  _gPaso2,
                  (v) => setState(() => _gPaso2 = v),
                ),
                _groundingItem(
                  'Nombra 3 sonidos que puedes escuchar',
                  _gPaso3,
                  (v) => setState(() => _gPaso3 = v),
                ),
                _groundingItem(
                  'Nombra 2 olores que puedes identificar',
                  _gPaso4,
                  (v) => setState(() => _gPaso4 = v),
                ),
                _groundingItem(
                  'Nombra 1 sabor que recuerdes o sientas',
                  _gPaso5,
                  (v) => setState(() => _gPaso5 = v),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _gPaso1 = _gPaso2 =
                            _gPaso3 = _gPaso4 = _gPaso5 = false;
                      });
                    },
                    child: const Text(
                      'Reiniciar ejercicio',
                      style: TextStyle(color: kPrimaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _groundingItem(
      String text, bool value, ValueChanged<bool> onChanged) {
    return CheckboxListTile(
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      contentPadding: EdgeInsets.zero,
      activeColor: kPrimaryColor,
      title: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}
