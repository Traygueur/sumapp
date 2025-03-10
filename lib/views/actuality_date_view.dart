import 'package:flutter/material.dart';
import 'package:sumapp/scrap.dart';
import 'package:intl/intl.dart';
import 'read_article_view.dart';

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
    List<String> titleList = selectedDate != null
        ? globalArticleTitles.entries
        .where((entry) => entry.value[0] == DateFormat("yyyy/MM/dd").format(selectedDate!))
        .map((entry) => entry.key)
        .toList()
        : [];

    return Scaffold(
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
              child: titleList.isEmpty
                  ? Center(child: Text("Aucun article trouvé pour cette date."))
                  : ListView.builder(
                itemCount: titleList.length,
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
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            summary,
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
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
          ],
        ),
      ),
    );
  }
}
