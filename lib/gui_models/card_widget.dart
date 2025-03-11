import 'package:flutter/material.dart';
import 'package:sumapp/views/read_article_view.dart';

class ArticleList extends StatelessWidget {
  final Map<String, List<String>> titles;
  final String day;

  const ArticleList({
    super.key,
    required this.titles,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    List<String> titleList = titles.entries
        .where((entry) => entry.value[0] == day)
        .map((entry) => entry.key)
        .toList();
    final int articleCount = titleList.length;

    return ListView.builder(
        itemCount: articleCount,
        itemBuilder: (context, index) {
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    titles[titleList[index]]?[1] ?? "Contenu non disponible",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        String title = titleList[index];
                        String summary = titles[title]?[1] ?? "Résumé non disponible";
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
                      child: const Text("Lire l'article"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
  }
}
