import 'package:flutter/material.dart';
import 'package:sumapp/models/request_script.dart';
import 'package:sumapp/models/scrap.dart';
import 'package:sumapp/views/read_article_view.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class newsScreen extends StatefulWidget {
  const newsScreen({super.key});

  @override
  State<newsScreen> createState() => _newsScreenState();
}

class _newsScreenState extends State<newsScreen> {
  String text = "";
  List<String> titles = globalArticleTitles.entries
      .where((entry) => entry.value[0] == DateFormat("yyyy/MM/dd").format(DateTime.now()))
      .map((entry) => entry.key)
      .toList();

  @override
  void initState() {
    super.initState();
    newsFunction(titles);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReadArticleView(
        title: "What's news today?",
        summary: text,
      ),
    );
  }

  Future<void> newsFunction(List<String> titles) async {
    String titlesString = titles.join(", ");
    String result = await MistralAPI.getNews(titlesString);

    if (mounted) {
      setState(() {
        text = utf8.decode(result.codeUnits);
      });
    }
  }
}
