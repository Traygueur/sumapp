import 'package:flutter/material.dart';
import 'package:sumapp/models/scrap.dart';
import 'package:intl/intl.dart';
import 'read_article_view.dart';
import 'package:sumapp/gui_models/navigation_drawer.dart';

import 'package:sumapp/gui_models/card_widget.dart';


class Actualite extends StatelessWidget {
  Actualite({super.key});

  void sortedDateFunction() async{
    HtmlFetcher scraper = HtmlFetcher();
    await scraper.sortArticlesByDate();
  }

  @override
  Widget build(BuildContext context) {
    sortedDateFunction();
    String today = DateFormat("yyyy/MM/dd").format(DateTime.now()); //"2025/03/10";

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text("Actualités du jour"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ArticleList(titles: globalArticleTitles, day: today,)
      ),
    );
  }
}