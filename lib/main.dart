import 'package:flutter/material.dart';
import 'package:sumapp/views/authentification_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/scrap.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'views/actuality_view.dart';
import 'views/actuality_date_view.dart';
import 'package:intl/date_symbol_data_local.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(MyApp());
  HtmlFetcher scraper = HtmlFetcher();
  await scraper.fetchHtml();
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Authentification(),
    );
  }
}