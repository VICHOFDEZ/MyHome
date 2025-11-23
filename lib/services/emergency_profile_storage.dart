// lib/services/emergency_profile_storage.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/emergency_profile.dart';

class EmergencyProfileStorage {
  static const _key = 'emergency_profile';

  static Future<void> saveProfile(EmergencyProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(profile.toMap()));
  }

  static Future<EmergencyProfile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);

    if (data == null) return null;

    final map = jsonDecode(data);
    return EmergencyProfile.fromMap(map);
  }

  static Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_key);
  }
}
