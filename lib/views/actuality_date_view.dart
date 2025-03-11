import 'package:flutter/material.dart';
import 'package:sumapp/gui_models/navigation_drawer.dart';
import 'package:sumapp/models/scrap.dart';
import 'package:intl/intl.dart';
import 'read_article_view.dart';
import 'package:intl/intl.dart';
import 'read_article_view.dart';
import 'package:sumapp/gui_models/card_widget.dart';


class ActualityDateView extends StatefulWidget {
  const ActualityDateView({super.key});

  @override
  State<ActualityDateView> createState() => _ActualityDateViewState();
}

class _ActualityDateViewState extends State<ActualityDateView> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    String selectedDateFormat = selectedDate != null
      ? DateFormat("yyyy/MM/dd").format(selectedDate!)
      : DateFormat("yyyy/MM/dd").format(DateTime.now());

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text("Rechercher par date"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              readOnly: true, // Empêche la saisie manuelle
              decoration: InputDecoration(
                labelText: "Sélectionner une date",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                        _dateController.text = DateFormat("yyyy/MM/dd").format(pickedDate);
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedDate != null) {
                  print("Recherche des articles pour la date : ${_dateController.text}");
                  setState(() {}); // Mettre à jour la liste des articles affichés
                }
              },
              child: Text("Rechercher"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ArticleList(titles: globalArticleTitles, day: selectedDateFormat,),
            ),
          ],
        ),
      ),
    );
  }
}
