import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:html/parser.dart' as html_parser;

class HtmlFetcher extends StatefulWidget {
  @override
  _HtmlFetcherState createState() => _HtmlFetcherState();
}

class _HtmlFetcherState extends State<HtmlFetcher> {
  List<String> dates = [];
  String _htmlContent = "Appuie sur le bouton pour récupérer le code source";
  String _statusMessage = "";
  List<String> articleLinks = [];
  Map<String, String> articleTitles = {}; // Dictionnaire pour stocker les titres des articles
  Map<String, String> articleContents = {}; // Dictionnaire pour stocker les contenus des articles

  @override
  void initState() {
    super.initState();
    generateDateList();
  }

  void generateDateList() {
    DateTime now = DateTime.now();
    for (int i = 0; i < 11; i++) {
      dates.add(DateFormat("yyyy/MM/dd").format(now.subtract(Duration(days: i))));
    }
  }

  Future<void> fetchHtml() async {
    articleLinks.clear();
    articleTitles.clear();
    articleContents.clear();

    for (String date in dates) {
      final url = 'https://www.zataz.com/$date';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        extractLinks(response.body, date);
      } else if (response.statusCode == 404) {
        setState(() {
          _statusMessage = "Aucun article trouvé pour certaines dates.";
        });
      } else {
        setState(() {
          _statusMessage = "Erreur : ${response.statusCode}";
        });
        break;
      }
    }

    await fetchArticleTitles();
    setState(() { _statusMessage = "Articles mis à jour"; });
  }

  void extractLinks(String html, String date) {
    RegExp regex = RegExp(r'<h2[^>]*class="blog-title"[^>]*>(.*?)<\/h2>', dotAll: true);
    Iterable<Match> matches = regex.allMatches(html);

    for (var match in matches) {
      if (match != null) {
        RegExp regexLink = RegExp(r'href="([^"]+)"');
        Match? matchLink = regexLink.firstMatch(match.group(0)!);
        if (matchLink != null) {
          String link = matchLink.group(1)!;
          if (!articleLinks.contains(link)) {
            articleLinks.add(link);
          }
        }
      }
    }
  }

  Future<void> fetchArticleTitles() async {
    List<Future<void>> requests = articleLinks.map((article) async {
      final response = await http.get(Uri.parse(article));
      if (response.statusCode == 200) {
        var document = html_parser.parse(response.body);

        var titleElement = document.querySelector("h1.blog-title a");
        String title = titleElement != null ? titleElement.text.trim() : "Titre inconnu";

        var contentElement = document.querySelector("div.gdl-blog-full");
        String content = contentElement != null ? contentElement.innerHtml.trim() : "Contenu non disponible";

        print("\n====== ARTICLE EXTRAIT ======\n$title\n$content\n===========================\n"); // Debug pour voir ce qui est récupéré

        setState(() {
          articleTitles[article] = title;
          articleContents[article] = content;
        });
      }
    }).toList();

    await Future.wait(requests);
    setState(() {});
  }

  void openArticlePage(String url) {
    String title = articleTitles[url] ?? "Titre inconnu";
    String content = articleContents[url] ?? "Contenu non disponible";
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticlePage(title: title, content: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Extracteur HTML")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: fetchHtml,
              child: Text("Récupérer les articles des 10 derniers jours"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_statusMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: articleTitles.entries.map((entry) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () => openArticlePage(entry.key),
                    child: Text(entry.value, textAlign: TextAlign.center),
                  ),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArticlePage extends StatelessWidget {
  final String title;
  final String content;

  ArticlePage({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Text(content),
        ),
      ),
    );
  }
}