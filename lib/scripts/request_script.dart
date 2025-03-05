import 'package:http/http.dart' as http;
import 'dart:convert';

class MistralAPI {
  static const String apiKey = 'soQOlM2mOkPc92exxkpWsKlsqGEX6uKp'; // À stocker dans .env pour sécurité
  static const String model = 'mistral-small-latest';
  static const String url = 'https://api.mistral.ai/v1/chat/completions';

  static Future<String> getSummary(String articleContent) async {
    final String prompt = "Résumé cet article :" + articleContent;

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
}
