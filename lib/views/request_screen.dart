import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children:[
            ElevatedButton(
              onPressed: _temporary,
              child: const Text('Start request'),
            ),
          ]
        )
      ),
    );
  }

  Future<String> _sendRequest(String prompt) async {
    const String apiKey = 'soQOlM2mOkPc92exxkpWsKlsqGEX6uKp';
    const String model = 'mistral-small-latest';
    const String url = 'https://api.mistral.ai/v1/chat/completions';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {
            'role': 'user',
            'content': prompt,
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content']; // Récupération de la réponse
    } else {
      throw Exception('Erreur ${response.statusCode}: ${response.body}');
    }
  }

  void _getMistralResponse(String prompt) async {
    try {
      String response = await _sendRequest(prompt);
      print("Réponse de Mistral AI: $response");
    } catch (e) {
      print("Erreur: $e");
    }
  }

  _temporary() {
    _getMistralResponse("Bonjour !");
  }

}

