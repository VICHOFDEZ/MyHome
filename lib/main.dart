import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:intl/date_symbol_data_local.dart';

// === Importa tus pantallas ===
import 'screens/home_screen.dart';
import 'screens/reminders_screen.dart';
import 'screens/technicians_screen.dart';
import 'screens/classes_screen.dart';
import 'screens/food_screen.dart';
import 'screens/simulador_vida_foranea_screen.dart';
import 'screens/quick_help_screen.dart';
import 'screens/nearby_technicians_screen.dart';
import 'screens/zonas_peligrosas_screen.dart';
import 'screens/vias_reversibles_screen.dart';
import 'screens/bienestar_calma_screen.dart';

// === Configuración del plugin de notificaciones ===
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inicializar datos de formato de fecha (para DateFormat)
  await initializeDateFormatting('es_CL', null);

  tz.initializeTimeZones();

  // Inicialización del plugin en Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // 🔔 Pide permiso de notificación (Android 13+)
  final androidPlugin = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  if (androidPlugin != null) {
    final granted = await androidPlugin.requestNotificationsPermission();
    if (granted ?? false) {
      debugPrint('✅ Permiso de notificaciones concedido');
    } else {
      debugPrint('❌ Permiso de notificaciones denegado');
    }
  }

  runApp(const MyHomeApp());
}

// === Clase principal de la app ===
class MyHomeApp extends StatelessWidget {
  const MyHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyHome',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/reminders': (context) => const RemindersScreen(),
        '/technicians': (context) => const TechniciansScreen(),
        '/classes': (context) => const ClassesScreen(),
        '/food': (context) => const FoodScreen(),
        '/simulador': (context) => const SimuladorVidaForaneaScreen(),
        '/nearbyTechnicians': (context) => const NearbyTechniciansScreen(),
        '/quickHelp': (context) => const QuickHelpScreen(),
        '/zonas': (context) => const ZonasPeligrosasScreen(),
        '/vias': (context) => const ViasReversiblesMapScreen(),
        '/bienestar': (context) => const BienestarCalmaScreen(),
      },
    );
  }
}
