import 'package:flutter/material.dart';
import 'package:sumapp/models/scrap.dart';
import 'package:intl/intl.dart';
import 'read_article_view.dart';
import 'package:sumapp/views/navigation_drawer.dart';


class Actualite extends StatelessWidget {
  Actualite({super.key});

  void someFunction() async{
    print("Lancé");
    HtmlFetcher scraper = HtmlFetcher();
    await scraper.sortArticlesByDate();
  }

  @override
  Widget build(BuildContext context) {
    someFunction();
    String today = "2025/03/10";//DateFormat("yyyy/MM/dd").format(DateTime.now());

    List<String> titleList = globalArticleTitles.entries
        .where((entry) => entry.value[0] == today)
        .map((entry) => entry.key)
        .toList();

    final int articleCount = titleList.length;
    print(titleList);
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text("Actualités du jour"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: articleCount, // Simulation avec 5 articles
          itemBuilder: (context, index) {
            String title = titleList[index];
            String summary = globalArticleTitles[title]?[1] ?? "Résumé non disponible";
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleList[index].toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      globalArticleTitles[titleList[index]]?[1] ?? "Contenu non disponible",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigation vers `ReadArticleView`
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReadArticleView(
                                title: title,
                                summary: summary,
                              ),
                            ),
                          );
                        },
                        child: Text("Lire l'article"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}