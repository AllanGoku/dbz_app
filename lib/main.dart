import 'package:flutter/material.dart';
import 'PageAccueil.dart';
import 'PageConnexion.dart';
import 'PageInscription.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dbz app',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        appBarTheme: AppBarTheme(
          color: Colors.orange[600],
          iconTheme: IconThemeData(
            color: Colors.blueAccent,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>  PageConnexion(),
        '/accueil': (context) => PageAccueil(),
        '/inscription': (context) => PageInscription(),
      },
    );
  }
}
