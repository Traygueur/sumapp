import 'package:flutter/material.dart';

class ArticleList extends StatelessWidget {
  final Map<String, String> titles;

  const ArticleList({
    super.key,
    required this.titles,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> titleList = titles.values.toList();
    final int articleCount = titleList.length >= 5 ? 5 : titleList.length;

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
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque auctor...",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {},
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
