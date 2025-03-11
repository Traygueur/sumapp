import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client.auth;
  Future<String> loginWithEmailPassword(String email, String password) async {
    try {
      final response = await supabase.signInWithPassword(email: email, password: password);
      if (response.user == null) {
        return "Erreur inconnue";
      }
      if (response.user?.identities?.isEmpty ?? true) {
        return "Compte en attente de confirmation.";
      }
      return "success";
    } on AuthException catch (e) {
        return e.message; // Retourne message d'erreur de Supabase
    } catch (e) {
        return 'Erreur de connexion : $e';
    }
  }
  Future<String> signUp(String email, String password) async {
    try {
      final response = await supabase.signUp(email: email, password: password);
      if (response.user == null) {
        return "Erreur inconnue";
      }

      if (response.user?.identities?.isEmpty ?? true) {
        return "Mail already used.";
      }

      return 'success';
    } on AuthException catch (e) {
      return e.message; // Retourne message d'erreur de Supabase
    } catch (e) {
      return 'Erreur d\'inscription : $e';
    }
  }
}
