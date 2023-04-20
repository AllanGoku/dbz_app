import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageAccueil extends StatelessWidget {
  PageAccueil({super.key});
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // This widget is the root of your application.

  String recupMail(){
    String mail = "";
    _prefs.then((SharedPreferences prefs) {
      mail = prefs.getString("mailConnexion")!;
    });
    return mail;
  }
  String test(){
    print(recupMail());
    return "test";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page d'accueil"),
        automaticallyImplyLeading: false
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Salut Super Guerrier " + recupMail() + " !"),
            Text(test()),
          ]
        ),
      )
    );
  }
}