import 'package:flutter/material.dart';
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
                        _dateController.text = "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
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
                  // Ici, tu pourras appeler une fonction pour récupérer les articles de cette date
                }
              },
              child: Text("Rechercher"),
            ),
            const SizedBox(height: 20),

            // const ArticleList(),
          ],
        ),
      ),
    );
  }
}
