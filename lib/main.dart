import 'package:flutter/material.dart';
import 'package:sumapp/views/authentification_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'scrap.dart';
import 'views/actuality_view.dart';
import 'views/actuality_date_view.dart';

void main()async{
  await Supabase.initialize(
    url: 'https://jqtwfuiwgxnfxdyfgyln.supabase.co',  // Remplace avec ton URL Supabase
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpxdHdmdWl3Z3huZnhkeWZneWxuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA1NzgwMzQsImV4cCI6MjA1NjE1NDAzNH0.LMVmbj5A8A7dbRJ4xRzh5JChbEzao6Bc6WkUXJZlgco',            // Remplace avec ta clé Anon
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Authentification(),
    );
  }
}