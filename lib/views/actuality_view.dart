import 'package:flutter/material.dart';
import 'package:sumapp/scrap.dart';

class Actualite extends StatelessWidget {
  Actualite({super.key});
  @override

  Widget build(BuildContext context) {
    final List<String> titleList = globalArticleTitles.values.toList();
    final int articleCount = titleList.length >= 5 ? 5 : titleList.length;
    print(titleList);
    return Scaffold(
      appBar: AppBar(
        title: Text("Actualités du jour"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: articleCount, // Simulation avec 5 articles
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
                      style: TextStyle(
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