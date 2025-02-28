import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'scrap.dart';

class Authentification extends StatefulWidget {
  const Authentification({super.key});

  @override
  State<Authentification> createState() => _AuthentificationState();

}


class _AuthentificationState extends State<Authentification> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginWithEmailPassword(String email, String password) async {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    // Vérification si la connexion a réussi
    if (response.user == null) {
      print('Erreur lors de la connexion : Aucune réponse de l\'utilisateur');
    } else {
      print('Connexion réussie');
      print('Utilisateur connecté : ${response.user?.email}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HtmlFetcher()),
      );
      // Tu peux utiliser 'response.user' pour obtenir les informations de l'utilisateur
      // Si tu veux la session : response.session
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SumAPP Authentification")),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "MotDePasse"),
            ),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text;
                String password = passwordController.text;
                await loginWithEmailPassword(email, password);
              },
              child: Text("Se connecter"),),
            ElevatedButton(onPressed: ()async{
              final response = await Supabase.instance.client.auth.signUp(
                email : emailController.text,
                password: passwordController.text

              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HtmlFetcher()),
              );
            }, child: Text("Créer un compte")),
          ],
        ),
      ),
    );
  }

}



