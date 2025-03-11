import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client.auth;

  Future<bool> loginWithEmailPassword(String email, String password) async {
    try {
      final response = await supabase.signInWithPassword(email: email, password: password);
      return response.user != null;
    } catch (e) {
      print('Erreur de connexion : $e');
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      final response = await supabase.signUp(email: email, password: password);
      return response.user != null;
    } catch (e) {
      print('Erreur d\'inscription : $e');
      return false;
    }
  }
}
