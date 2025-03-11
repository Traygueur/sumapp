import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sumapp/models/authentification.dart';
import 'package:sumapp/views/actuality_view.dart';


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
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text(
          "SumApp Authentification",
          style: TextStyle(
            fontFamily: 'Poppins', // Le nom de la famille de la police
            fontWeight: FontWeight.bold, // épaisseur de la police
          ),
        ),
        backgroundColor: Color(0xFFFDB90C),
      ),
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
                  String message = await authService.loginWithEmailPassword(
                    emailController.text,
                    passwordController.text,
                  );
                  if (message != "success") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  } else if (message == "success") {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Actualite()),
                          (route) => false, // Supprime toutes les routes précédentes
                    );
                  }
                },
                child: Text("Se connecter"),
              ),
              ElevatedButton(
                onPressed: () async {
                  String message = await authService.signUp(
                    emailController.text,
                    passwordController.text,
                  );
                  if (message != "success") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
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
