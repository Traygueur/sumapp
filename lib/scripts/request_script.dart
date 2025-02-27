import 'package:http/http.dart' as http;
import 'dart:convert';


Future<String> sendRequest(String prompt) async {
  const String apiKey = 'soQOlM2mOkPc92exxkpWsKlsqGEX6uKp'; // flutter dot env 5.2.1 : utilisation du fichier .env (à la racine)
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

void getMistralResponse(String prompt) async {
  try {
    String response = await sendRequest(prompt);
    print("Réponse de Mistral AI: $response");
  } catch (e) {
    print("Erreur: $e");
  }
}