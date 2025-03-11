import 'package:sumapp/views/actuality_date_view.dart';
import '../views/actuality_view.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:html/parser.dart' as html_parser;
import 'request_script.dart';
import 'dart:convert';
import 'package:flutter/material.dart';



Map<String, List<String>> globalArticleTitles = {};

class HtmlFetcher{
  List<String> dates = [];
  String _htmlContent = "Appuie sur le bouton pour récupérer le code source";
  String _statusMessage = "";
  List<String> articleLinks = [];
  Map<String, String> articleTitles = {}; // Dictionnaire pour stocker les titres des articles
  Map<String, String> articleContents = {}; // Dictionnaire pour stocker les contenus des articles
  Map<String, String> articleDates = {};
  List<String> articleLinksMonde = [];
  Map<String, String> articleContentsMonde = {}; // Dictionnaire pour stocker les contenus des articles de LeMonde
  Map<String, String> articleDatesMonde = {};
  List<List<String>> articleContentDate = [[],[]];


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
    fetchHtmlLemonde();
    generateDateList();

    for (String date in dates) {
      final url = 'https://www.zataz.com/$date';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        extractLinks(response.body, date);
      } else {
          break;
      }
    }

    await fetchArticleTitles();
  }

  sortArticlesByDate() {
    // Convertion entrées de Map en liste
    List<MapEntry<String, List<String>>> entries = globalArticleTitles.entries.toList();

    // Trier la liste par date (format "yyyy/MM/dd")
    entries.sort((a, b) {
      DateTime dateA = DateFormat("yyyy/MM/dd").parse(a.value[0]);
      DateTime dateB = DateFormat("yyyy/MM/dd").parse(b.value[0]);
      return dateB.compareTo(dateA); // ordre décroissant : les plus récents en premier
    });

    // Recréer Map trié
    globalArticleTitles = Map<String, List<String>>.fromEntries(entries);
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
            articleDates[link] = date;
          }
        }
      }
    }
  }

  Future<void> fetchArticleTitles() async {
    for (String article in articleLinks) {
      final response = await http.get(Uri.parse(article));

      if (response.statusCode == 200) {
        var document = html_parser.parse(response.body);

        var titleElement = document.querySelector("h1.blog-title a");
        String title = titleElement != null ? titleElement.text.trim() : "Titre inconnu";

        var contentElement = document.querySelector("div.gdl-blog-full");
        String content = contentElement != null ? contentElement.innerHtml.trim() : "Contenu non disponible";

        String summary;
        try {
          // print("🔵 Envoi de la requête à MistralAPI pour : $title");
          summary = await MistralAPI.getSummary(content);
          // print("🟢 Réussi : Résumé reçu pour '$title'");
        } catch (e) {
          // print("🔴 Erreur lors de l'appel à MistralAPI pour '$title' : $e");
          summary = "Résumé non disponible";
        }

          articleTitles[article] = title;
          articleContents[article] = content;
          String summaryUtf8 = utf8.decode(summary.codeUnits);
          globalArticleTitles[title] = [articleDates[article] ?? "", summaryUtf8];

        // print("Attente de 1 secondes avant la prochaine requête...");
        await Future.delayed(Duration(seconds: 1));
      }
    }
  }


  Future<void> fetchHtmlLemonde() async {
    final url = 'https://www.lemondeinformatique.fr/securite-informatique-3.html';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      extractArticlesFromLeMondeInformatique(response.body);
    }
    await fetchArticleMonde();
  }


  void extractArticlesFromLeMondeInformatique(String html) {
    var document = html_parser.parse(html);
    var articleDivs = document.querySelectorAll("div.col-sm-8.col-xs-7");

    for (var div in articleDivs) {
      // Extraction date depuis <span class="theme"><b>...</b></span>
      var dateElement = div.querySelector("span.theme b");
      String rawDate = dateElement != null ? dateElement.text.trim() : "";

      // Suppression préfixe "le " si présent
      String cleanedDate = rawDate.replaceFirst(RegExp(r'^le\s+'), '').trim();

      // Conversion convertDate
      String formattedDate = convertDate(cleanedDate);

      // Extraction lien depuis <a class="title" href="...">
      var linkElement = div.querySelector("a.title");
      String link = linkElement != null ? linkElement.attributes['href'] ?? "" : "";

      if (link.isNotEmpty && cleanedDate.isNotEmpty) {
        if (!articleLinksMonde.contains(link)) {
          articleLinksMonde.add(link);
          // Stocker date formatée dans Map (Le Monde)
          articleDates[link] = formattedDate;
        }
      }
    }
  }

  String convertDate(String dateText) {
    // Mapping des mois
    Map<String, String> moisMap = {
      "Janvier": "01",
      "Février": "02",
      "Mars": "03",
      "Avril": "04",
      "Mai": "05",
      "Juin": "06",
      "Juillet": "07",
      "Août": "08",
      "Septembre": "09",
      "Octobre": "10",
      "Novembre": "11",
      "Décembre": "12",
    };

    List<String> parts = dateText.split(" ");
    if (parts.length != 3) return "Format invalide";

    String day = parts[0].padLeft(2, '0'); // S'assurer que le jour est sur 2 chiffres
    String month = moisMap[parts[1]] ?? "00"; // Convertir le mois en nombre
    String year = parts[2];

    return "$year/$month/$day";
  }




  Future<void> fetchArticleMonde() async {
    for (String article in articleLinksMonde) {
      final response = await http.get(Uri.parse(article));

      if (response.statusCode == 200) {
        var document = html_parser.parse(response.body);

        var titleElement = document.querySelector("h1.mb-small");
        String title = titleElement != null ? titleElement.text.trim() : "Titre inconnu";

        var contentElement = document.querySelector("div.col-primary");
        String content = contentElement != null ? contentElement.innerHtml.trim() : "Contenu non disponible";

        String summary;
        try {
          summary = await MistralAPI.getSummary(content);
        } catch (e) {
          summary = "Résumé non disponible";
        }
         articleTitles[article] = title;
          articleContents[article] = content;
        String summaryUtf8 = utf8.decode(summary.codeUnits);
        globalArticleTitles[title] = [articleDates[article] ?? "", summaryUtf8];

        await Future.delayed(Duration(seconds: 1));
      }
    }
  }
}

