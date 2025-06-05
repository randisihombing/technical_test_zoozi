import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier extends StateNotifier<String?> {
  AuthNotifier() : super(null);

  Future<void> login(String token) async {
    // Simpan ke state
    state = token;

    // Simpan ke storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('token');
  }

  Future<void> logout() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, String?>((ref) {
  final notifier = AuthNotifier();
  notifier.loadFromStorage(); // load on startup
  return notifier;
});
