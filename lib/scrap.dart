import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HtmlFetcher extends StatefulWidget {
  @override
  _HtmlFetcherState createState() => _HtmlFetcherState();
}

class _HtmlFetcherState extends State<HtmlFetcher> {

  String formatdate = '';

  @override
  void initState() {
    super.initState();
    formatdate = DateFormat("yyyy/MM/dd").format(DateTime.now());
  }

  String _htmlContent = "Appuie sur le bouton pour récupérer le code source";




  Future<void> fetchHtml() async {
    final response = await http.get(Uri.parse('https://www.zataz.com/'+formatdate));

    if (response.statusCode == 200) {
      setState(() {
        _htmlContent = response.body;
      });
    } else {
      setState(() {
        _htmlContent = "Erreur : ${response.statusCode}";
      });
    }

    RegExp regex = RegExp(r'<h2[^>]*class="blog-title"[^>]*>(.*?)<\/h2>', dotAll: true);
    Iterable<Match> matches = regex.allMatches(_htmlContent);

    for(var match in matches){
      if (match != null) {
        String innerContent = match.group(0)!; // Contenu interne sans <div>...</div>
        print(innerContent);
        RegExp regexlink = RegExp(r'href="([^"]+)"');
        Match? matchlink = regexlink.firstMatch(innerContent);
        if(matchlink != null){
          String link = matchlink.group(1)!;
          print(link);
        }
      } else {
        print("Aucune div avec la classe 'blog-date' trouvée.");
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Extracteur HTML")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: fetchHtml,
            child: Text("Récupérer le HTML"),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Text(_htmlContent),
            ),
          ),
        ],
      ),
    );
  }
}