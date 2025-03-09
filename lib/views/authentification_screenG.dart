import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sumapp/models/authentification.dart';


class Authentification extends StatefulWidget {
  const Authentification({super.key});

  @override
  State<Authentification> createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService(); // Instance du service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SumAPP Authentification")),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
        child: Center(
          child: Column(
            children: [
              CupertinoTextField(
                controller: emailController,
                placeholder: 'Required',
                prefix: Text('Mail', style: TextStyle(fontWeight: FontWeight.bold)),
                decoration: BoxDecoration(),
              ),
              Divider(thickness: 1, color: Colors.grey),
              CupertinoTextField(
                controller: passwordController,
                placeholder: 'Required',
                obscureText: true, // Cache le mot de passe
                prefix: Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
                decoration: BoxDecoration(),
              ),
              ElevatedButton(
                onPressed: () async {
                  bool success = await authService.loginWithEmailPassword(
                    emailController.text,
                    passwordController.text,
                  );
                  if (success) {
                    // Navigator.pushNamed(context, '/home'); // Redirige vers la page d'accueil
                    print("Connexion réussi");
                  }
                },
                child: Text("Se connecter"),
              ),
              ElevatedButton(
                onPressed: () async {
                  bool success = await authService.signUp(
                    emailController.text,
                    passwordController.text,
                  );
                  if (success) {
                    // Navigator.pushNamed(context, '/welcome'); // Redirige vers une autre page
                    print("Inscription réussi");
                  }
                },
                child: Text("Créer un compte"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
